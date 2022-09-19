LEASuite_ReportService = LEASuite_Object:New();

function LEASuite_ReportService:New(obj)

    self._aceGUI = LibStub(LEASuite_Constants.LIB_ACE_GUI);
    self._mrpService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_MRP_SERVICE);
    self._charDescService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_CHARACTER_DESCRIPTION_SERVICE);
    self._recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);

    self.OptionsTable = nil;

    self.ConfigRegistry = nil;

    self.FullName = "";
    self.OocName = "";
    self.PersonalDesc = "";
    self.Statement = "";

    self:RegisterOptions();
    for k,v in pairs(LEASuiteAddonDataSettingsDB.char.IncidentReports) do
        self:_addIncidentToUi(k, v)
    end

    return self:RegisterNew(obj);

    --[===[
        LEASuiteAddonDataSettingsDB.char.IncidentReports
        IncidentDetails =
        {
            Title,
            IncidentTypes = {},
            Location,
            ReportedOnDateTime,
            OccurredOnDateTime,
            Circumstances,
        },
        Witnesses =
        {
            [1] =
            {
                Details =
                {
                    FullName,
                    OocName,
                    PersonalDescription,
                    Statement,
                }
            }
        },
        Suspects =
        {
            [1] =
            {
                Details =
                {
                    FullName,
                    OocName,
                    PersonalDescription,
                    Statement,
                },
                Offences =
                {
                    [1] =
                    {
                        CategoryId,
                        OffenceId,
                    }
                }
            }
        }
    ]===]

end
    
function LEASuite_ReportService:ResetViewModel()
    LEASuite_SavedVars.Reports = {};
end

function LEASuite_ReportService:RegisterOptions()

    self.OptionsTable = 
    {
        type = "group",
        childGroups = "tab",
        args =
        {
            incidentReportsTab =
            {
                name = "Incident Reports",
                type = "group",
                childGroups = "tree",
                order = 0,
                args =
                {
                    addNewIncidentReport =
                    {
                        type = "group",
                        name = "|TInterface\\BUTTONS\\UI-PlusButton-Up:16:16:0:0|t Add new incident",
                        order = 0,
                        args =
                        {
                            addNewIncidentButton =
                            {
                                type = "execute",
                                name = "Add new incident report",
                                order = 0,
                                func = 
                                    function()
                                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);
                                        local newKey = reportService:GetNextRandomKey();

                                        local newDetails = reportService:_addIncidentToDb(newKey);
                                        reportService:_addIncidentToUi(newKey, newDetails);
                                    end
                            }
                        }
                    },
                }
            },
            pnbTab =
            {
                name = "Pocket Notebook",
                type = "group",
                order = 1,
                args =
                {

                }
            },
            theKingsLawTab =
            {
                name = "The Kings Law",
                type = "group",
                order = 1,
                args =
                {

                }
            },
            jnopTab =
            {
                name = "JNOP",
                type = "group",
                order = 2,
                args =
                {

                }
            },
            helpTab =
            {
                name = "Help",
                type = "group",
                order = 3,
                args =
                {
                    
                }
            }
        }
    }
    
    self.ConfigRegistry = LibStub(LEASuite_Constants.LIB_ACE_CONFIG):RegisterOptionsTable("Office of Justice - LEA Suite", self.OptionsTable);

end

function LEASuite_ReportService:_addIncidentToUi(incidentKey, incidentData)
    self.OptionsTable.args.incidentReportsTab.args[incidentKey] =
    {
        type = "group",
        name = incidentData.IncidentDetails.Title .. (incidentData.IncidentDetails.OccuredOnDateTime 
            and string.format(" (%s)", incidentData.IncidentDetails.OccuredOnDateTime)
            or ""),
        childGroups = "tab",
        args =
        {
            incidentDetailsTab = self:_addIncidentDetails(),
            witnessesTab = self:_addWitnessDetails(incidentData.Witnesses),
            suspectsTab = self:_addSuspectDetails(incidentData.Suspects),
        }
    };

end

function LEASuite_ReportService:_addIncidentToDb(incidentKey)
    local now = C_DateAndTime.GetCurrentCalendarTime();
    local formattedNow = string.format("%d-%02d-%02d %02d:%02d", now.year, now.month, now.monthDay, now.hour, now.minute);

    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey] = {
        IncidentDetails = {
            Title = "New incident",
            IncidentTypes = {},
            Location = nil,
            ReportedOnDateTime = formattedNow,
            OccurredOnDateTime = formattedNow,
            Circumstances = nil,
        },
        Witnesses = {},
        Suspects = {},
    };

    return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey];
end

function LEASuite_ReportService:_addIncidentDetails()
    return {
        name = "Incident Details",
        type = "group",
        order = 0,
        args =
        {
            incidentDetailsTitle =
            {
                name = "Incident Details",
                type = "header",
                order = 0,
            },
            incidentDetailsDesc =
            {
                name = "|cff00ffffProvide the basic details pertaining to this incident below by summarising the information around what's happened as well as when and where.|r",
                type = "description",
                order = 1,
            },
            title =
            {
                name = "Title",
                type = "input",
                width = "full",
                order = 2,
                get = 
                    function(info)
                        local key = info[#info-2];
                        return LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.Title;
                    end,
                set = 
                    function(info, value)
                        local key = info[#info-2];
                        LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.Title = value;
                    end
            },
            incidentType =
            {
                name = "Incident type(s)",
                type = "multiselect",
                width = "full",                                        
                order = 3,
                dialogControl = "Dropdown",
                values = 
                {
                    "Aggression", 
                    "Contraband", 
                    "Capital"
                },
                get =
                    function(info, keyname)
                        local key = info[#info-2];
                        return LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.IncidentTypes[keyname];
                    end,
                set =
                    function(info, keyname, value)
                        local key = info[#info-2];
                        LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.IncidentTypes[keyname] = value;
                    end,
            },
            location =
            {
                name = "Location",
                type = "input",
                width = "full",                                        
                order = 4,
                get = 
                    function(info)
                        local key = info[#info-2];
                        return LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.Location;
                    end,
                set = 
                    function(info, value)
                        local key = info[#info-2];
                        LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.Location = value;
                    end
            },
            reportedOnDateTime =
            {
                name = "Reported on (date and time)",
                type = "input",
                width = "full",                                        
                order = 5,
                get = 
                    function(info)
                        local key = info[#info-2];
                        return LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.ReportedOnDateTime;
                    end,
                set = 
                    function(info, value)
                        local key = info[#info-2];
                        LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.ReportedOnDateTime = value;
                    end
            },
            occurredOnDateTime =
            {
                name = "Occurred on (date and time)",
                type = "input",
                width = "full",                                        
                order = 6,
                get = 
                    function(info)
                        local key = info[#info-2];
                        return LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.OccurredOnDateTime;
                    end,
                set = 
                    function(info, value)
                        local key = info[#info-2];
                        LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.OccurredOnDateTime = value;
                    end
            },
            circumstances =
            {
                name = "Circumstances of the incident",
                type = "input",
                multiline = 6,
                width = "full",                                        
                order = 7,
                get = 
                    function(info)
                        local key = info[#info-2];
                        return LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.Circumstances;
                    end,
                set = 
                    function(info, value)
                        local key = info[#info-2];
                        LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.Circumstances = value;
                    end
            }
        }
    };
end

function LEASuite_ReportService:_addWitnessDetails(witnessData)
    local witnessUiData = {
        name = "Witnesses",
        type = "group",
        order = 1,
        childGroups = "select",
        args =
        {
            addWitnessTitle =
            {
                name = "Witnesses",
                type = "header",
                order = 0,
            },
            addWitnessDesc =
            {
                name = "|cff00ffffAdd a new witness to this incident report by clicking the add new witness button below.\n\nSelecting different witnesses can be done from the dropdown list to the right.|r",
                type = "description",
                order = 1,
            },
            addWitnessButton =
            {
                name = "Add new witness",
                type = "execute",
                order = 2,
                func =
                    function(info)                        
                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);
                        local newWitnessKey = reportService:GetNextRandomKey();
                        local incidentKey = info[#info-2];

                        local newDetails = LEASuite_ReportService.AddWitnessToDb(incidentKey, newWitnessKey);                        
                        LEASuite_ReportService.AddWitnessToUi(                            
                            reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.witnessesTab,
                            newWitnessKey,
                            newDetails);
                    end
            }
        }
    }

    if witnessData then
        for witnessKey, witnessDetails in pairs(witnessData) do
            LEASuite_ReportService.AddWitnessToUi(witnessUiData, witnessKey, witnessDetails);
        end
    end

    return witnessUiData;
end

function LEASuite_ReportService.AddWitnessToUi(targetDbTable, newWitnessKey, witnessData)
    local selectDisplay = {};
    if witnessData.Details.FullName then
        table.insert(selectDisplay, witnessData.Details.FullName);
    end    
    if witnessData.Details.OocName then
        table.insert(selectDisplay, string.format("(%s)", witnessData.Details.OocName));
    end

    targetDbTable.args[newWitnessKey] = {
        type = "group",
        name = #selectDisplay > 0 and table.concat(selectDisplay, " ") or "Unknown witness",
        childGroups = "tab",
        order = 0,
        args =
        {
            detailsTab =
            {
                name = "Witness Details",
                type = "group",
                order = 0,
                args =
                {
                    fullName =
                    {
                        name = "Full name",
                        type = "input",
                        width = "normal",
                        order = 0,
                        get = 
                            function(info)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.FullName;
                            end,
                        set = 
                            function(info, value)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.FullName = value;
                            end
                    },
                    oocName =
                    {
                        name = "OOC name",
                        type = "input",
                        width = "normal",
                        order = 1,
                        get = 
                            function(info)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.OocName;
                            end,
                        set = 
                            function(info, value)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.OocName = value;
                            end
                    },
                    personalDescription =
                    {
                        name = "Personal description",
                        type = "input",
                        multiline = 6,
                        width = "full",
                        order = 2,
                        get = 
                            function(info)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.PersonalDescription;
                            end,
                        set = 
                            function(info, value)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.PersonalDescription = value;
                            end
                    },
                    descriptionBuilderButton =
                    {
                        name = "Open description builder",
                        type = "execute",
                        width = "full",
                        order = 3,
                        func =
                            function(info)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                reportService:SetDescriptionForSubject(
                                    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details);
                            end,
                    },
                    breaker1 =
                    {
                        type = "header",
                        name = "",
                        order = 4,
                    },
                    statement =
                    {
                        name = "Statement",
                        type = "input",
                        multiline = 6,
                        width = "full",
                        order = 5,
                        get = 
                            function(info)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.Statement;
                            end,
                        set = 
                            function(info, value)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.Statement = value;
                            end
                    },
                    openRecorderButton =
                    {
                        name = "Open statement recorder",
                        type = "execute",
                        width= "full",
                        order = 6,
                        func =
                            function(info)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                reportService:SetStatementForSubject(
                                    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details);
                            end,
                    }
                }
            },      
        }
    }
    
end

function LEASuite_ReportService.AddWitnessToDb(incidentKey, witnessKey)
    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey] = {
        Details = {
            FullName = "New witness",
            OocName = nil,
            PersonalDescription = nil,
            Statement = nil,
        }
    };

    return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey];
end

function LEASuite_ReportService:_addSuspectDetails(suspectData)
    local suspectUiData = {
        name = "Suspects",
        type = "group",
        order = 2,
        childGroups = "select",
        args =
        {
            addSuspectTitle =
            {
                name = "Suspects",
                type = "header",
                order = 0,
            },
            addSuspectDesc =
            {
                name = "|cff00ffffAdd a new suspect to this incident report by clicking the add new suspect button below.\n\nSelecting different suspects can be done from the dropdown list to the right.|r",
                type = "description",
                order = 1,
            },
            addSuspectButton =
            {
                name = "Add new suspect",
                type = "execute",
                order = 2,
                func =
                    function(info)                        
                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);
                        local newSuspectKey = reportService:GetNextRandomKey();
                        local incidentKey = info[#info-2];

                        local newDetails = LEASuite_ReportService.AddSuspectToDb(incidentKey, newSuspectKey);                        
                        LEASuite_ReportService.AddSuspectToUi(                            
                            reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.suspectsTab,
                            newSuspectKey,
                            newDetails);
                    end
            }
        }
    }

    if suspectData then
        for suspectKey, suspectDetails in pairs(suspectData) do
            LEASuite_ReportService.AddSuspectToUi(suspectUiData, suspectKey, suspectDetails);
        end
    end

    return suspectUiData;
end

function LEASuite_ReportService.AddSuspectToUi(targetDbTable, newSuspectKey, suspectData)
    local selectDisplay = {};
    if suspectData.Details.FullName then
        table.insert(selectDisplay, suspectData.Details.FullName);
    end    
    if suspectData.Details.OocName then
        table.insert(selectDisplay, string.format("(%s)", suspectData.Details.OocName));
    end

    targetDbTable.args[newSuspectKey] = {
        type = "group",
        name = #selectDisplay > 0 and table.concat(selectDisplay, " ") or "Unknown suspect",
        childGroups = "tab",
        order = 0,
        args =
        {
            detailsTab =
            {
                name = "Suspect Details",
                type = "group",
                order = 0,
                args =
                {
                    fullName =
                    {
                        name = "Full name",
                        type = "input",
                        width = "normal",
                        order = 0,
                        get = 
                            function(info)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.FullName;
                            end,
                        set = 
                            function(info, value)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.FullName = value;
                            end
                    },
                    oocName =
                    {
                        name = "OOC name",
                        type = "input",
                        width = "normal",
                        order = 1,
                        get = 
                            function(info)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.OocName;
                            end,
                        set = 
                            function(info, value)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.OocName = value;
                            end
                    },
                    personalDescription =
                    {
                        name = "Personal description",
                        type = "input",
                        multiline = 6,
                        width = "full",
                        order = 2,
                        get = 
                            function(info)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.PersonalDescription;
                            end,
                        set = 
                            function(info, value)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.PersonalDescription = value;
                            end
                    },
                    descriptionBuilderButton =
                    {
                        name = "Open description builder",
                        type = "execute",
                        width = "full",
                        order = 3,
                        func =
                            function(info)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                reportService:SetDescriptionForSubject(
                                    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details);
                            end,
                    },
                    breaker1 =
                    {
                        type = "header",
                        name = "",
                        order = 4,
                    },
                    statement =
                    {
                        name = "Statement",
                        type = "input",
                        multiline = 6,
                        width = "full",
                        order = 5,
                        get = 
                            function(info)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.Statement;
                            end,
                        set = 
                            function(info, value)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.Statement = value;
                            end
                    },
                    openRecorderButton =
                    {
                        name = "Open statement recorder",
                        type = "execute",
                        width= "full",
                        order = 6,
                        func =
                            function(info)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                reportService:SetStatementForSubject(
                                    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details);
                            end,
                    }
                }
            },
            offencesTab = self:_addSuspectOffences(suspectData.Offences)
        }
    }    
end

function LEASuite_ReportService.AddSuspectToDb(incidentKey, suspectKey)
    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey] = {
        Details =
        {
            FullName = "New suspect",
            OocName = nil,
            PersonalDescription = nil,
            Statement = nil,
        },
        Offences = {}
    };

    return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey];
end

function LEASuite_ReportService:_addSuspectOffences(offenceData)
    local offencesUiData = 
    {
        name = "Suspected Offences",
        type = "group",
        childGroups = "select",
        order = 1,
        args = 
        {
            suspectedOffencesTitle =
            {
                name = "Suspected Offences",
                type = "header",
                order = 0,
            },
            incidentDetailsDesc =
            {
                name = "|cff00ffffOffencees and their categories are as per the format of the King's Law.\n\nAdd offences and switch between them using the add offence button below or the dropdown to the right.|r",
                type = "description",
                order = 1,
            },
            addOffenceButton =
            {
                type = "execute",
                name = "Add offence",
                order = 2,
            }
        }
    };

    if offenceData then
        for offenceKey, offenceDetails in pairs(offenceData) do
            LEASuite_ReportService.AddSuspectOffenceToUi(offencesUiData, offenceKey, offenceDetails);
        end
    end

    return offencesUiData;
end

function LEASuite_ReportService:AddSuspectOffenceToUi(targetDbTable, newOffenceKey, offenceData)

    targetDbTable.args[newOffenceKey] = {
        name = "PLACEHOLDER", --Offences[offenceData.CategoryId][offenceData.OffenceId]
        type = "group",
        args =
        {
            offenceCategory =
            {
                type = "select",
                name = "Offence category",
                values = {"Offences Against the Person"},
                order = 0,
                width = "full",
            },
            offence =
            {
                type = "select",
                name = "Offence",
                values = {"S1. Common Assault"},
                order = 1,
                width = "full",
            },
            delete =
            {
                type = "execute",
                name = "Remove this offence",
                order = 3,
            }
        }
    }
end

function LEASuite_ReportService:AddSuspectOffenceToDb(incidentKey, suspectKey, offenceKey)
    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey] = {
        {
            DisplayName = "New offence",
            CategoryId = nil,
            OffenceId = nil,
        }
    };

    return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey];
end

function LEASuite_ReportService:SetDescriptionForSubject(node)    

    self._charDescService:ShowDescriptionBuilder(function(characterData)
        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);
        local charDescService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_CHARACTER_DESCRIPTION_SERVICE);
        local descriptionText = charDescService:BuildDescriptionMatrixText(characterData);

        local characterFullNameTable = {};

        if charDescService:UseCharacterData(characterData.UseTitle, characterData.Title) then
            table.insert(characterFullNameTable, characterData.Title);
        end

        if charDescService:UseCharacterData(characterData.UseFirstName, characterData.FirstName) then
            table.insert(characterFullNameTable, characterData.FirstName);
        end

        if charDescService:UseCharacterData(characterData.UseLastName, characterData.LastName) then
            table.insert(characterFullNameTable, characterData.LastName);
        end
        
        node.FullName = #characterFullNameTable > 0 and table.concat(characterFullNameTable, " ");
        node.OocName = characterData.UseOocName and characterData.OocName;
        node.PersonalDescription = descriptionText;
        
        LibStub("AceConfigRegistry-3.0"):NotifyChange("Office of Justice - LEA Suite");
    end);

end

function LEASuite_ReportService:SetStatementForSubject(node)

    self._recorderService:ShowRecorderWindow(function(statementText)

        node.Statement = statementText;
        
        LibStub("AceConfigRegistry-3.0"):NotifyChange("Office of Justice - LEA Suite");
    end);

end

function LEASuite_ReportService:ShowLeaSuiteWindow()

    local configDialog = LibStub(LEASuite_Constants.LIB_ACE_CONFIG_DIALOG);

    configDialog:SetDefaultSize("Office of Justice - LEA Suite", 700, 800);
    configDialog:Open("Office of Justice - LEA Suite");

end

function LEASuite_ReportService:_buildMainFrame()

    local leaSuiteFrame = self._aceGUI:Create("Window");
    leaSuiteFrame:EnableResize(false);

    leaSuiteFrame:SetUserData("reportFrameContainer", reportFrameContainer);

    leaSuiteFrame:SetCallback("OnClose", function(widget)
        local aceGUI = LibStub(LEASuite_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);

    return leaSuiteFrame;

end

function LEASuite_ReportService:GetNextRandomKey()
    return date("!%Y%m%d%H%M%S");
end