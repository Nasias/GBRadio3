GBR_ReportService = GBR_Object:New();

function GBR_ReportService:New(obj)

    self._aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
    self.ConfigRegistry = nil;

    if GBRSavedVar_Reports == nil then
        GBRSavedVar_Reports = {};
    end

    self:RegisterOptions();

    return self:RegisterNew(obj);

end

function GBR_ReportService:RegisterOptions()

    local options = 
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
                    addNewIncidentReportButton =
                    {
                        type = "execute",
                        name = "Add new incident report",
                        width = 1.2,
                        order = -999,
                    },
                    ["1"] =
                    {
                        type = "group",
                        name = "Assault in Old Town (13/09/2022)",
                        childGroups = "tab",
                        args =
                        {
                            incidentDetailsTab =
                            {
                                name = "Incident Details",
                                type = "group",
                                order = 0,
                                args =
                                {
                                    title =
                                    {
                                        name = "Title",
                                        type = "input",
                                        width = "full",
                                        order = 0,
                                    },
                                    incidentType =
                                    {
                                        name = "Incident type",
                                        type = "select",
                                        width = 1.6,                                        
                                        order = 1,
                                        values = {"Aggression", "Contraband", "Capital"}
                                    },
                                    location =
                                    {
                                        name = "Location",
                                        type = "input",
                                        width = 1.6,                                        
                                        order = 3,
                                    },
                                    reportedOnDateTime =
                                    {
                                        name = "Reported on",
                                        type = "input",
                                        width = 1.6,                                        
                                        order = 4,
                                    },
                                    occurredOnDateTime =
                                    {
                                        name = "Occurred on",
                                        type = "input",
                                        width = 1.6,                                        
                                        order = 5,
                                    },
                                    description =
                                    {
                                        name = "Description",
                                        type = "input",
                                        multiline = 6,
                                        width = "full",                                        
                                        order = 6,
                                    }
                                }
                            },
                            witnessesTab =
                            {
                                name = "Witnesses",
                                type = "group",
                                order = 1,
                                args =
                                {
                                    ["1"] =
                                    {
                                        type = "group",
                                        name = "Witness",
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
                                                    },
                                                    oocName =
                                                    {
                                                        name = "OOC name",
                                                        type = "input",
                                                        width = "normal",
                                                        order = 1,
                                                    },
                                                    personalDescription =
                                                    {
                                                        name = "Personal description",
                                                        type = "input",
                                                        multiline = 6,
                                                        width = "full",
                                                        order = 2,
                                                    },
                                                    autoFillFromTrpButton =
                                                    {
                                                        name = "Auto-fill description with targets TRP",
                                                        type = "execute",
                                                        width = "full",
                                                        order = 3,
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
                                                    },
                                                    openRecorderButton =
                                                    {
                                                        name = "Open recorder",
                                                        type = "execute",
                                                        width= "full",
                                                        order = 6,
                                                    }
                                                }
                                            },      
                                        }
                                    },
                                    addWitness =
                                    {
                                        name = "Add new witness",
                                        type = "execute",
                                        order = 999
                                    }
                                }
                            },
                            suspectsTab =
                            {
                                name = "Suspects",
                                type = "group",
                                order = 2,
                                args =
                                {
                                    ["1"] =
                                    {
                                        type = "group",
                                        name = "Suspect",
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
                                                    },
                                                    oocName =
                                                    {
                                                        name = "OOC name",
                                                        type = "input",
                                                        width = "normal",
                                                        order = 1,
                                                    },
                                                    personalDescription =
                                                    {
                                                        name = "Personal description",
                                                        type = "input",
                                                        multiline = 6,
                                                        width = "full",
                                                        order = 2,
                                                    },
                                                    autoFillFromTrpButton =
                                                    {
                                                        name = "Auto-fill description with targets TRP",
                                                        type = "execute",
                                                        width = "full",
                                                        order = 3,
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
                                                    },
                                                    openRecorderButton =
                                                    {
                                                        name = "Open recorder",
                                                        type = "execute",
                                                        width= "full",
                                                        order = 6,
                                                    }
                                                }
                                            },
                                            offencesTab =
                                            {
                                                name = "Suspected Offences",
                                                type = "group",
                                                childGroups = "tree",
                                                order = 1,
                                                args = 
                                                {
                                                    addOffenceButton =
                                                    {
                                                        type = "execute",
                                                        name = "Add offence",
                                                        order = -999,
                                                    },
                                                    ["1"] = 
                                                    {
                                                        name = "S1. Common Assault",
                                                        type = "group",
                                                        inline = false,
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
                                                                name = "Remove offence",
                                                                order = 3,
                                                            }
                                                        }
                                                    },
                                                }
                                            }                                    
                                        }
                                    },
                                    addSuspect =
                                    {
                                        name = "Add new suspect",
                                        type = "execute",
                                        order = 999
                                    }
                                }
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
    
    self.ConfigRegistry = LibStub(GBR_Constants.LIB_ACE_CONFIG):RegisterOptionsTable("GBR_Reports", options);

end

function GBR_ReportService:ShowReportingWindow()

    local mainFrame = self:_buildMainFrame();

    local configDialog = LibStub(GBR_Constants.LIB_ACE_CONFIG_DIALOG);

    configDialog:Open("GBR_Reports", mainFrame);
    mainFrame:SetTitle("LEA Suite");
    mainFrame:SetWidth(900);
    mainFrame:SetHeight(800);
    mainFrame:EnableResize(true);

end

function GBR_ReportService:_buildMainFrame()

    local reportFrame = self._aceGUI:Create("Window");

    reportFrame:SetCallback("OnClose", function(widget)
        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);

    return reportFrame;

end

function GBR_ReportService:_buildRecorderFrame()

    local recorderFrame = self._aceGUI:Create("Window");

    recorderFrame:SetCallback("OnClose", function(widget)
        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);

    recorderFrame:SetLayout("Flow");
    recorderFrame:SetHeight(450);
    recorderFrame:SetWidth(600);
    recorderFrame:EnableResize(false);
    recorderFrame:SetTitle("Statement Recorder");

    local recorderFrameActors = self._aceGUI:Create("Dropdown");
    recorderFrameActors:SetLabel("Record actors")
    recorderFrameActors:SetList({UnitName("player")});
    recorderFrameActors:SetMultiselect(true);
    recorderFrameActors:SetRelativeWidth(0.7);
    recorderFrame:AddChild(recorderFrameActors);

    local recorderFrameActorsAddTargetButton = self._aceGUI:Create("Button");
    recorderFrameActorsAddTargetButton:SetText("Add target to actors");
    recorderFrameActorsAddTargetButton:SetRelativeWidth(0.3);
    recorderFrame:AddChild(recorderFrameActorsAddTargetButton);

    local recorderStartRecordingButton = self._aceGUI:Create("Button");
    recorderStartRecordingButton:SetText("Start recording");
    recorderStartRecordingButton:SetRelativeWidth(0.3);
    recorderFrame:AddChild(recorderStartRecordingButton);

    local recorderStopRecordingButton = self._aceGUI:Create("Button");
    recorderStopRecordingButton:SetText("Stop recording");
    recorderStopRecordingButton:SetRelativeWidth(0.3);
    recorderFrame:AddChild(recorderStopRecordingButton);

    local recorderStatusText = self._aceGUI:Create("Label");
    recorderStatusText:SetText("[Statement recorder is recording...]");
    recorderStatusText:SetColor(0, 1, 0);
    recorderStatusText:SetRelativeWidth(1);
    recorderFrame:AddChild(recorderStatusText);

    local recorderRecordedText = self._aceGUI:Create("MultiLineEditBox");
    recorderRecordedText:SetLabel("Recorded statement");
    recorderRecordedText:SetNumLines(15);
    recorderRecordedText:SetRelativeWidth(1);
    recorderFrame:AddChild(recorderRecordedText);

    local recorderReminderText = self._aceGUI:Create("Label");
    recorderReminderText:SetText("NOTE: Don't forget to take a copy of your recorded statement!\nUse Ctrl + A (select all) and Ctrl + C (copy) to take a copy. Use Ctrl + P (paste) to paste it in to your destination.");
    recorderReminderText:SetColor(0, 1, 1);
    recorderReminderText:SetRelativeWidth(1);
    recorderFrame:AddChild(recorderReminderText);

    local recorderClose = self._aceGUI:Create("Button");
    recorderClose:SetText("Close recorder");
    recorderClose:SetRelativeWidth(0.3);
    recorderFrame:AddChild(recorderClose);

end