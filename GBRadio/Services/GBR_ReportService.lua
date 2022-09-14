GBR_ReportService = GBR_Object:New();

function GBR_ReportService:New(obj)

    self._aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
    self.ConfigRegistry = nil;

    self.RecorderActors = {UnitName("player")};
    self.RecordedTextWidget = nil;
    self.RecordedText = "";

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
                                        name = "Reported on (date and time)",
                                        type = "input",
                                        width = 1.6,                                        
                                        order = 4,
                                    },
                                    occurredOnDateTime =
                                    {
                                        name = "Occurred on (date and time)",
                                        type = "input",
                                        width = 1.6,                                        
                                        order = 5,
                                    },
                                    description =
                                    {
                                        name = "Circumstances of the incident",
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
                                childGroups = "select",
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
                                    addWitnessTitle =
                                    {
                                        name = "Add a new witness",
                                        type = "header",
                                        order = 0,
                                    },
                                    addWitnessDesc =
                                    {
                                        name = "|cff00ffffAdd a new witness to this incident report by clicking the add new witness button below, and selecting the witness from the dropdown list to the right.|r",
                                        type = "description",
                                        order = 1,
                                    },
                                    addWitnessButton =
                                    {
                                        name = "Add new witness",
                                        type = "execute",
                                        order = 2
                                    }
                                }
                            },
                            suspectsTab =
                            {
                                name = "Suspects",
                                type = "group",
                                order = 2,
                                childGroups = "select",
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
                                                        name = "Auto-populate from target",
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
                                                childGroups = "select",
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
    
    self.ConfigRegistry = LibStub(GBR_Constants.LIB_ACE_CONFIG):RegisterOptionsTable("LEA Suite", options);

end

function GBR_ReportService:ShowLeaSuiteWindow()

    local mainFrame = self:_buildMainFrame();

    local configDialog = LibStub(GBR_Constants.LIB_ACE_CONFIG_DIALOG);

    configDialog:SetDefaultSize("LEA Suite", 700, 800);
    configDialog:Open("LEA Suite", mainFrame);

end

function GBR_ReportService:_buildMainFrame()

    local leaSuiteFrame = self._aceGUI:Create("Window");
    leaSuiteFrame:SetTitle("LEA Suite");
    leaSuiteFrame:EnableResize(false);

    leaSuiteFrame:SetUserData("reportFrameContainer", reportFrameContainer);

    leaSuiteFrame:SetCallback("OnClose", function(widget)
        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);

    return leaSuiteFrame;

end