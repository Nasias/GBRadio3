LEASuite_ExporterService = LEASuite_Object:New();

function LEASuite_ExporterService:New(obj)

    self._aceGUI = LibStub(LEASuite_Constants.LIB_ACE_GUI);
    self._offenceService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_OFFENCE_SERVICE);

    self.Widgets = {
        ExporterFrame = nil,
    };

    return self:RegisterNew(obj);
end

function LEASuite_ExporterService:ShowExporter(incidentModel)

    self:_buildExportFrame();
    self:_applyModel(incidentModel);

end

function LEASuite_ExporterService:_applyModel(incidentModel)

    local incidentReportDocument = self.Widgets.ExporterFrame:GetUserData("incidentDetailsText");
    local witnessesDocument = self.Widgets.ExporterFrame:GetUserData("witnessDetailsText");
    local suspectsDocument = self.Widgets.ExporterFrame:GetUserData("suspectDetailsText");

    incidentReportDocument:SetText(self:_buildIncidentReportDocument(incidentModel));
    witnessesDocument:SetText(self:_buildWitnessesDocument(incidentModel));
    suspectsDocument:SetText(self:_buildSuspectsDocument(incidentModel));

end

function LEASuite_ExporterService:_getValueOrDefault(value, default)

    return value and value:len() >0 and value or default;

end

function LEASuite_ExporterService:_buildIncidentReportDocument(incidentModel)

    local title = self:_getValueOrDefault(incidentModel.IncidentDetails.Title, "Untitled incident");
    local reportedOnDateTime = self:_getValueOrDefault(incidentModel.IncidentDetails.ReportedOnDateTime, "An unknown date and time");
    local location = self:_getValueOrDefault(incidentModel.IncidentDetails.Location, "an unknown location");
    local occurredOnDateTime = self:_getValueOrDefault(incidentModel.IncidentDetails.OccurredOnDateTime, "An unknown date and time");
    local selectedIncidentTypes = {};
    if incidentModel.IncidentDetails.IncidentTypes then
        for k,v in pairs(incidentModel.IncidentDetails.IncidentTypes) do
            if v then
                table.insert(selectedIncidentTypes, self._offenceService:GetIncidentTypeForId(k));
            end
        end
    end
    local incidentTypes = (#selectedIncidentTypes > 0 and table.concat(selectedIncidentTypes, ", ")) or "Unknown incident type";
    local circumstances = self:_getValueOrDefault(incidentModel.IncidentDetails.Circumstances, "None");
    local selectedReporters = {};
    if incidentModel.Witnesses then
        for k,v in pairs(incidentModel.Witnesses) do
            if v.Details.IsIncidentReporter then
                local name = "- " .. (v.Details.FullName and v.Details.FullName:len() > 0 and v.Details.FullName or "Unknown witness");
                name = name .. (v.Details.OocName and v.Details.OocName:len() > 0 and string.format(" (%s)", v.Details.OocName)) or "";
                table.insert(selectedReporters, name);
            end
        end
    end
    local reportingWitnesses = (#selectedReporters > 0 and table.concat(selectedReporters, "\n")) or "None";

    local lines =
    {
        [[**--------------- [ Incident Report ] ---------------**]],
        "",
        string.format("**%s**", title),
        string.format("**Reported on:** %s", reportedOnDateTime),
        string.format("**Occured at:** %s on %s", location, occurredOnDateTime),
        string.format("**Incident type(s):** %s", incidentTypes),
        "",
        [[**------------------- [ Details ] -------------------**]],
        "",
        "**Reported by**",
        reportingWitnesses,
        "",
        "**Circumstances**",
        circumstances,
    };

    return table.concat(lines, "\n");

end

function LEASuite_ExporterService:_formatWitnessData(witnessData)
    return string.format(
        "**%s**\n__Description__\n%s\n__Statement__\n%s", 
        witnessData.Name, 
        witnessData.PersonalDescription, 
        witnessData.Statement);
end

function LEASuite_ExporterService:_buildWitnessesDocument(incidentModel)

    local title = self:_getValueOrDefault(incidentModel.IncidentDetails.Title, "Untitled incident");
    local witnesses = {};
    if incidentModel.Witnesses then
        for k,v in pairs(incidentModel.Witnesses) do
            local witnessData = {};
            witnessData.Name = v.Details.FullName and v.Details.FullName:len() > 0 and v.Details.FullName or "Unknown witness";
            witnessData.Name = witnessData.Name .. ((v.Details.OocName and v.Details.OocName:len() > 0 and string.format(" (%s)", v.Details.OocName)) or "");

            witnessData.PersonalDescription = v.Details.PersonalDescription and v.Details.PersonalDescription:len() > 0 and v.Details.PersonalDescription
                or "- There is no description for this witness";

            witnessData.Statement = v.Details.Statement and v.Details.Statement:len() > 0 and v.Details.Statement
                or "- There is no statement for this witness";

            table.insert(witnesses, self:_formatWitnessData(witnessData));
        end
    end

    local witnessesDetails = (#witnesses > 0 and table.concat(witnesses, "\n\n" .. "----------------------------------------" .. "\n\n")) or "No witnesses";

    local lines =
    {
        [[**------------- [ Witness Counterpart ] -------------**]],
        "",
        string.format("**Witness list for report:** %s", title),
        "",
        witnessesDetails
    };

    return table.concat(lines, "\n");

end

function LEASuite_ExporterService:_formatSuspectData(suspectData)
    return string.format(
        "**%s**\n__Offences__\n%s\n__Description__\n%s\n__Statement__\n%s", 
        suspectData.Name,
        suspectData.Offences,
        suspectData.PersonalDescription,
        suspectData.Statement);
end

function LEASuite_ExporterService:_buildSuspectsDocument(incidentModel)

    local title = self:_getValueOrDefault(incidentModel.IncidentDetails.Title, "Untitled incident");
    local suspects = {};
    if incidentModel.Suspects then
        for k,v in pairs(incidentModel.Suspects) do
            local suspectData = {};
            suspectData.Name = v.Details.FullName and v.Details.FullName:len() > 0 and v.Details.FullName or "Unknown suspect";
            suspectData.Name = suspectData.Name .. ((v.Details.OocName and v.Details.OocName:len() > 0 and string.format(" (%s)", v.Details.OocName)) or "");

            suspectData.PersonalDescription = v.Details.PersonalDescription and v.Details.PersonalDescription:len() > 0 and v.Details.PersonalDescription
                or "- There is no description for this suspect";

            suspectData.Statement = v.Details.Statement and v.Details.Statement:len() > 0 and v.Details.Statement
                or "- There is no statement for this suspect";

            suspectData.OffenceList = {};
            for offenceKey, offenceValue in pairs(v.Offences) do
                if offenceValue.CategoryId and offenceValue.OffenceId then
                    table.insert(
                        suspectData.OffenceList, 
                        string.format("- %s, %s",
                            self._offenceService:GetOffencesForCategory(offenceValue.CategoryId)[offenceValue.OffenceId],
                            self._offenceService:GetOffenceCategoryName(offenceValue.CategoryId)));
                end
            end

            suspectData.Offences = #suspectData.OffenceList > 0 and table.concat(suspectData.OffenceList, "\n") or "- There are no offences listed against this suspect";
            table.insert(suspects, self:_formatSuspectData(suspectData));
        end
    end
    local suspectDetails = (#suspects > 0 and table.concat(suspects, "\n\n" .. "----------------------------------------" .. "\n\n")) or "No suspects";

    local lines =
    {
        [[**------------- [ Suspect Counterpart ] -------------**]],
        "",
        string.format("**Suspect list for report:** %s", title),
        "",
        suspectDetails
    };

    return table.concat(lines, "\n");

end

function LEASuite_ExporterService:_buildExportFrame()

    local exporterFrame = self._aceGUI:Create("Window");
    exporterFrame:SetCallback("OnClose", function(widget)
        local aceGUI = LibStub(LEASuite_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);

    exporterFrame.frame:Raise();
    self.Widgets.ExporterFrame = exporterFrame;

    exporterFrame:SetLayout("Flow");
    exporterFrame:SetHeight(660);
    exporterFrame:SetWidth(500);
    exporterFrame:EnableResize(false);
    exporterFrame:SetTitle("Export Report");

    local exportDescription = self._aceGUI:Create("Label");
    exportDescription:SetRelativeWidth(1);
    exportDescription:SetText("|cff00ffffThe various pages in your incident report compose your compiled report document below. You can select and copy the information from below, and publish to preferred medium (such as Discord posts) to share with other members of your unit."
        .."\n\nIf you need to make changes to your report after publishing it, it's recommended that you change the details via LEASuite and re-export to maintain your source of truth.\n\n");
    exporterFrame:AddChild(exportDescription);

    local incidentDetailsGroup = self._aceGUI:Create("InlineGroup");
    incidentDetailsGroup:SetTitle("Incident details");
    incidentDetailsGroup:SetRelativeWidth(1);
    exporterFrame:AddChild(incidentDetailsGroup);

    local incidentDetailsDescription = self._aceGUI:Create("Label");
    incidentDetailsDescription:SetRelativeWidth(1);
    incidentDetailsDescription:SetText("|cff00ffffThe main incident report document for your report can be copied from below.\n\n");
    incidentDetailsGroup:AddChild(incidentDetailsDescription);

    local incidentDetailsText = self._aceGUI:Create("MultiLineEditBox");
    incidentDetailsText:SetLabel("Incident report document");
    incidentDetailsText:SetRelativeWidth(1);
    incidentDetailsText:DisableButton(true);
    incidentDetailsText:SetNumLines(6);
    incidentDetailsGroup:AddChild(incidentDetailsText);
    exporterFrame:SetUserData("incidentDetailsText", incidentDetailsText);

    local witnessDetailsGroup = self._aceGUI:Create("InlineGroup");
    witnessDetailsGroup:SetTitle("Witnesses");
    witnessDetailsGroup:SetRelativeWidth(1);
    exporterFrame:AddChild(witnessDetailsGroup);

    local witnessDetailsDescription = self._aceGUI:Create("Label");
    witnessDetailsDescription:SetRelativeWidth(1);
    witnessDetailsDescription:SetText("|cff00ffffThe details and statements provided by any witnesses on your report can be copied from below.\n\n");
    witnessDetailsGroup:AddChild(witnessDetailsDescription);

    local witnessDetailsText = self._aceGUI:Create("MultiLineEditBox");
    witnessDetailsText:SetLabel("Witness details and statements");
    witnessDetailsText:SetRelativeWidth(1);
    witnessDetailsText:DisableButton(true);
    witnessDetailsText:SetNumLines(6);
    witnessDetailsGroup:AddChild(witnessDetailsText);
    exporterFrame:SetUserData("witnessDetailsText", witnessDetailsText);

    local suspectDetailsGroup = self._aceGUI:Create("InlineGroup");
    suspectDetailsGroup:SetTitle("Suspects");
    suspectDetailsGroup:SetRelativeWidth(1);
    exporterFrame:AddChild(suspectDetailsGroup);

    local suspectDetailsDescription = self._aceGUI:Create("Label");
    suspectDetailsDescription:SetRelativeWidth(1);
    suspectDetailsDescription:SetText("|cff00ffffThe details, statements and offences of any suspects on your report can be copied from below.\n\n");
    suspectDetailsGroup:AddChild(suspectDetailsDescription);

    local suspectDetailsText = self._aceGUI:Create("MultiLineEditBox");
    suspectDetailsText:SetLabel("Suspect details and statements");
    suspectDetailsText:SetRelativeWidth(1);
    suspectDetailsText:DisableButton(true);
    suspectDetailsText:SetNumLines(6);
    suspectDetailsGroup:AddChild(suspectDetailsText);
    exporterFrame:SetUserData("suspectDetailsText", suspectDetailsText);


end