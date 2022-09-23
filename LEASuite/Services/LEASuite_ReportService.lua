LEASuite_ReportService = LEASuite_Object:New();

function LEASuite_ReportService:New(obj)

    self._aceGUI = LibStub(LEASuite_Constants.LIB_ACE_GUI);
    self._mrpService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_MRP_SERVICE);
    self._charDescService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_CHARACTER_DESCRIPTION_SERVICE);
    self._recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);
    self._offenceService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_OFFENCE_SERVICE);

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
                    IsIncidentReporter,
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
                name = [[|TInterface\Store\category-icon-book:26:26:-4:0:64:64:13:51:13:51|t Incident Reports]],
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
                        width = "double",
                        args =
                        {
                            incidentReportTitle =
                            {
                                type = "description",
                                name = "Welcome to Incident Reports",
                                image = [[Interface\ICONS\INV_Misc_Book_09]],
                                fontSize = "large",
                                imageWidth = 40,
                                imageHeight = 40,
                                order = 0,
                            },
                            incidentReportDesc =
                            {
                                type = "description",
                                name = 
                                    "Use the LEA Suite incident report manager to build maintain your own incident reports."
                                    .. "\n\nIncident reports can be exported to copy + pastable Markdown which you can use to add your reports to platforms like Discord or forums to share them with the rest of your organisation."
                                    .. "\n\nStart by clicking the Add new incident report button below and selecting the new report.",
                                order = 1,
                            },
                            addNewIncidentButton =
                            {
                                type = "execute",
                                name = "Add new incident report",
                                order = 2,
                                func = 
                                    function()
                                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);
                                        local configDialogService = LibStub(LEASuite_Constants.LIB_ACE_CONFIG_DIALOG);

                                        local newKey = reportService:GetNextRandomKey();

                                        local newDetails = reportService:_addIncidentToDb(newKey);
                                        reportService:_addIncidentToUi(newKey, newDetails);
                                        configDialogService:SelectGroup(LEASuite_Constants.OPT_ADDON_ID, "incidentReportsTab", newKey);
                                    end
                            }
                        }
                    },
                }
            },
            pnbTab =
            {
                name = [[|TInterface\Store\category-icon-book:26:26:-4:0:64:64:13:51:13:51|t Pocket Notebook]],
                type = "group",
                order = 1,
                args =
                {
                    pocketNotebookTitle =
                    {
                        type = "description",
                        name = "Welcome to your Pocket Notebook",
                        image = [[Interface\ICONS\INV_Misc_Book_09]],
                        fontSize = "large",
                        imageWidth = 40,
                        imageHeight = 40,
                        order = 0,
                    },
                    pocketNotebookDesc =
                    {
                        type = "description",
                        name = 
                            "Use your pocket notebook to take notes and keep track of other details as you see fit.\n\nYour notes will persist between reloads and relogs. Just remember to click \"accept\" whenever you make a change.",
                        order = 1,
                    },
                    pocketNotebookNotes =
                    {
                        type = "input",
                        name = "Pocket Notebook",
                        multiline = 35,
                        width = "full",
                        get =
                            function(info)
                                return LEASuiteAddonDataSettingsDB.char.PocketNotebook;
                            end,
                        set =
                            function(info, value)
                                LEASuiteAddonDataSettingsDB.char.PocketNotebook = value;
                            end,
                    }
                }
            },
            theKingsLawTab =
            {
                name = [[|TInterface\Store\category-icon-services:26:26:-4:0:64:64:13:51:13:51|t The King's Law]],
                type = "group",
                order = 1,
                args =
                {
                    theKingsLaw =
                    {
                        type = "group",
                        name = "The King's Law",
                        order = 0,
                        args =
                        {
                            kingsLawTitle =
                            {
                                type = "description",
                                name = "Welcome to The King's Law Handbook",
                                image = [[Interface\ICONS\INV_MISC_NOTE_02]],
                                fontSize = "large",
                                imageWidth = 40,
                                imageHeight = 40,
                                order = 0,
                            },
                            kingsLawDescContainer =
                            {
                                type = "group",
                                inline = true,
                                name = "About the King's Law",
                                order = 1,
                                args =
                                {
                                    kingsLawDesc =
                                    {
                                        type = "description",
                                        name = 
                                            "The King's Law is the server-canon lawbook of Argent Dawn, EU. Built through community engagement by the Office of Justice, with help from guilds such as Stormwind Investigations, Stormwind City Guard and Echo Company, and through community engagement via The Royal Court's council and public committees."
                                            .. "\n\n|cff00ffffWant to contribute? Join the Royal Court Discord or join the weekly Court Council in-game.|r"
                                            .. "\n\n|cff00ffffFor a more comprehensive guide, visit the Office of Justice: Royal Criminal Archives below.|r",
                                        order = 0,
                                    },
                                    rcaLink =
                                    {
                                        type = "input",
                                        name = "Office of Justice: Royal Criminal Archives",
                                        get = 
                                            function()
                                                return "https://rca.officeofjustice.eu";
                                            end,
                                        width = "double",
                                        order = 1
                                    },
                                }
                            },                            
                            browseTitle =
                            {
                                type = "description",
                                name = "Navigate the handbook",
                                image = [[Interface\ICONS\INV_MISC_NOTE_02]],
                                fontSize = "large",
                                imageWidth = 40,
                                imageHeight = 40,
                                order = 2,
                            },
                            browseDescContainer =
                            {                                
                                type = "group",
                                inline = true,
                                name = "Categories and sections",
                                order = 3,
                                args =
                                {
                                    browseDesc =
                                    {
                                        type = "description",
                                        name = "Browse through the various offence sections and offences using the categories to the left.",
                                        order = 1,
                                    }
                                }
                            }
                        }
                    },
                }
            },
            -- jnopTab =
            -- {
            --     name = [[|TInterface\Store\category-icon-clothes:26:26:-4:0:64:64:13:51:13:51|t JNOP Protocol]],
            --     type = "group",
            --     order = 2,
            --     args =
            --     {

            --     }
            -- },
            -- helpTab =
            -- {
            --     name = [[|TInterface\Store\category-icon-placeholder:26:26:-4:0:64:64:13:51:13:51|t Help]],
            --     type = "group",
            --     order = 3,
            --     args =
            --     {
                    
            --     }
            -- }
        }
    }

    local theKingsLawOffences = self._offenceService:GetAllOffences();
    for key, offencePage in ipairs(theKingsLawOffences) do    
        self.OptionsTable.args.theKingsLawTab.args.theKingsLaw.args["offence-page-" .. key] = self:_addOffencePageToUi(key, offencePage);
    end
    
    self.ConfigRegistry = LibStub(LEASuite_Constants.LIB_ACE_CONFIG):RegisterOptionsTable(LEASuite_Constants.OPT_ADDON_ID, self.OptionsTable);

end

function LEASuite_ReportService:_addOffencePageToUi(key, offencePage)

    local offencePageLayout = 
    {
        type = "group",
        childGroups = "tree",
        name = offencePage.Title,
        order = key,
        args =
        {
            title =
            {
                type = "description",
                name = offencePage.Title,
                image = [[Interface\ICONS\INV_MISC_NOTE_02]],
                fontSize = "large",
                imageWidth = 40,
                imageHeight = 40,
                order = 0,
            },
            descriptionContainer =
            {                    
                type = "group",
                inline = true,
                name = "Category summary",
                width = "full",
                order = 1,
                args =
                {
                    description =
                    {
                        type = "description",
                        name = offencePage.Description,
                        order = 0
                    },
                }
            },
            descriptionFurtherInfoContainer =
            {                    
                type = "group",
                inline = true,
                name = "Category details",
                width = "full",
                order = 2,
                args =
                {
                    description =
                    {
                        type = "description",
                        name = offencePage.Title .. " contains " .. #offencePage.Offences .. " sections.\n\nExpand the category selector to the left to browse through these sections.",
                        order = 0
                    },
                }
            }
        }
    }

    for key, offence in ipairs(offencePage.Offences) do
        local offenceSectionLayout =
        {
            type = "group",
            name = offence.Title,
            order = key,
            args =
            {
                title =
                {
                    type = "description",
                    name = offence.Title,
                    image = [[Interface\ICONS\INV_MISC_NOTE_02]],
                    fontSize = "large",
                    imageWidth = 40,
                    imageHeight = 40,
                    order = 0,
                },
                descriptionContainer =
                {                    
                    type = "group",
                    inline = true,
                    name = "Offence summary",
                    width = "full",
                    order = 1,
                    args =
                    {
                        description =
                        {
                            type = "description",
                            name = offence.Description,
                            order = 0
                        },
                    }
                },
                offenceTypes =
                {
                    type = "group",
                    inline = true,
                    name = "Offence types",
                    width = "full",
                    order = 2,
                    args =
                    {
                        isPenaltyOffence =
                        {
                            type = "toggle",
                            name = "Penalty",
                            desc = "A fixed penalty notice (FPN) can be issued for a penalty offence without a court hearing or supervisor escalation.",
                            order = 0,
                            width = 0.7,
                            get =
                                function()
                                    return offence.IsPenaltyOffence;
                                end
                        },
                        isSummaryOffence =
                        {
                            type = "toggle",
                            name = "Summary",
                            desc = "A trial in the Magistrates Court, or a supervisor review is required for a summary offence, in order for the suspect to be lawfully convicted and sentenced.",
                            order = 1,
                            width = 0.7,
                            get =
                                function()
                                    return offence.IsSummaryOffence;
                                end
                        },
                        isIndictableOffence =
                        {
                            type = "toggle",
                            name = "Indictable",
                            desc = "A trial in the Crown Court, or a senior supervisor review is required for an indictable offence, in order for the suspect to be lawfully convicted and sentenced.",
                            order = 2,
                            width = 0.7,
                            get =
                                function()
                                    return offence.IsIndictableOffence;
                                end
                        },
                        isEitherWayOffence =
                        {
                            type = "toggle",
                            name = "Either way",
                            desc = "An offence can be classified as more than one type, in which case it's an either way offence. Use your best judgement in these situations to classify how punishment should be handled."
                            .. "\n\nIf the circumstances are severe, you should escalate it to a higher authority. Otherwise it may be minor enough for a milder approach to conviction and sentencing.|r",
                            order = 3,
                            width = 0.7,
                            get =
                                function()
                                    local offenceTypeCount = 0;
                                    
                                    if offence.IsPenaltyOffence then offenceTypeCount = offenceTypeCount + 1; end
                                    if offence.IsSummaryOffence then offenceTypeCount = offenceTypeCount + 1; end
                                    if offence.IsIndictableOffence then offenceTypeCount = offenceTypeCount + 1; end

                                    return offenceTypeCount > 1;
                                    
                                end
                        }
                    }
                },
                appliesWhen =
                {
                    type = "group",
                    inline = true,
                    name = [[|TInterface\LFGFRAME\UI-LFG-ICON-ROLES:20:20:-4:0:256:256:134:201:0:67|t Applies when]],
                    width = "full",
                    order = 3,
                    args =
                    {

                    }
                },
                doesntApplyWhen =
                {
                    type = "group",
                    inline = true,
                    name = [[|TInterface\LFGFRAME\UI-LFG-ICON-ROLES:20:20:-4:0:256:256:67:134:134:202|t Doesn't apply when]],
                    width = "full",
                    order = 4,
                    args =
                    {

                    }
                },
                sentencingGuidelines =
                {
                    type = "group",
                    inline = true,
                    name = [[|TInterface\LFGFRAME\UI-LFG-ICON-ROLES:20:20:-4:0:256:256:67:134:67:134|t Suggested sentences]],
                    width = "full",
                    order = 5,
                    args =
                    {

                    }
                },
            }
        }

        for appliesKey, appliesWhen in ipairs(offence.AppliesWhen) do
            offenceSectionLayout.args.appliesWhen.args["offence-applies-when-" .. appliesKey] =
            {
                type = "description",
                name = "• " .. appliesWhen,
                order = appliesKey,
            }
        end

        for appliesKey, appliesWhen in ipairs(offence.NotAppliesWhen) do
            offenceSectionLayout.args.doesntApplyWhen.args["offence-not-applies-when-" .. appliesKey] =
            {
                type = "description",
                name = "• " .. appliesWhen,
                order = appliesKey,
            }
        end

        for sentenceKey, sentence in ipairs(offence.SuggestedPunishments) do
            offenceSectionLayout.args.sentencingGuidelines.args["offence-suggested-punishment-" .. sentenceKey] =
            {
                type = "description",
                name = "• " .. sentence,
                order = sentenceKey,
            }
        end

        offencePageLayout.args["offence-sub-page-" .. key] = offenceSectionLayout;
    end

    return offencePageLayout;

end

function LEASuite_ReportService:_addIncidentToUi(incidentKey, incidentData)
    self.OptionsTable.args.incidentReportsTab.args[incidentKey] =
    {
        type = "group",
        name = incidentData.IncidentDetails.Title .. (incidentData.IncidentDetails.OccurredOnDateTime 
            and string.format(" (%s)", incidentData.IncidentDetails.OccurredOnDateTime)
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
        Evidence = {},
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

                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                        local title = LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.Title;
                        local occurredOn = LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.OccurredOnDateTime;

                        local displayTitle = title .. (occurredOn
                            and string.format(" (%s)", occurredOn)
                            or "");

                        reportService.OptionsTable.args.incidentReportsTab.args[key].name = displayTitle;
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
                    function()
                        local offenceService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_OFFENCE_SERVICE);
                        return offenceService:GetIncidentTypes();
                    end,
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
                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                        LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.OccurredOnDateTime = value;

                        local title = LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.Title;
                        local occurredOn = LEASuiteAddonDataSettingsDB.char.IncidentReports[key].IncidentDetails.OccurredOnDateTime;

                        local displayTitle = title .. (occurredOn
                            and string.format(" (%s)", occurredOn)
                            or "");

                        reportService.OptionsTable.args.incidentReportsTab.args[key].name = displayTitle;
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
            },
            breaker1 =
            {
                type = "header",
                name = "Export",
                order = 8,
            },
            exportDescription =
            {
                name = "|cff00ffffWhen you've filled in your incident details, witnesses and suspects, export your report to Discord by clicking the export button and pasting your fields in to your Discord server.|r",
                type = "description",
                order = 9,
            },
            export =
            {
                type = "execute",
                name = "Get Discord export string",
                order = 10,
                width = "full",
                func = 
                    function(info)
                        local incidentKey = info[#info-2];
                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);
                        local exporterService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_EXPORTER_SERVICE);

                        exporterService:ShowExporter(LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey]);
                    end
            },
            breaker2 =
            {
                type = "header",
                name = "Delete",
                order = 11,
            },
            deleteDescription =
            {
                name = "|cffff0000If you need to remove this incident report, then you can do so by clicking the button below. Just note that this can't be reversed.|r",
                type = "description",
                order = 12,
            },
            delete =
            {
                type = "execute",
                name = "Remove this incident",
                order = 13,
                width = "full",
                func = 
                    function(info)
                        local incidentKey = info[#info-2];

                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                        reportService.OptionsTable.args.incidentReportsTab.args[incidentKey] = nil;
                        LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey] = nil;
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
                        local configDialogService = LibStub(LEASuite_Constants.LIB_ACE_CONFIG_DIALOG);
                        local newWitnessKey = reportService:GetNextRandomKey();
                        local incidentKey = info[#info-2];

                        local newDetails = LEASuite_ReportService.AddWitnessToDb(incidentKey, newWitnessKey);                        
                        LEASuite_ReportService.AddWitnessToUi(                            
                            reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.witnessesTab,
                            newWitnessKey,
                            newDetails);
                            
                        configDialogService:SelectGroup(LEASuite_Constants.OPT_ADDON_ID, "incidentReportsTab", incidentKey, "witnessesTab", newWitnessKey, "detailsTab");
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
    if witnessData.Details.FullName and witnessData.Details.FullName:len() > 0 then
        table.insert(selectDisplay, witnessData.Details.FullName);
    end    
    if witnessData.Details.OocName and witnessData.Details.OocName:len() > 0 then
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
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.FullName = value;

                                local selectDisplay = {};
                                local fullName = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.FullName;
                                local oocName = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.OocName;

                                if fullName and fullName:len() > 0 then
                                    table.insert(selectDisplay, fullName);
                                end    
                                if oocName and oocName:len() > 0 then
                                    table.insert(selectDisplay, string.format("(%s)", oocName));
                                end

                                local displayName = #selectDisplay > 0 and table.concat(selectDisplay, " ") or "Unknown witness";

                                reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.witnessesTab.args[witnessKey].name = displayName;
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
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.OocName = value;

                                local selectDisplay = {};
                                local fullName = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.FullName;
                                local oocName = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.OocName;

                                if fullName and fullName:len() > 0 then
                                    table.insert(selectDisplay, fullName);
                                end    
                                if oocName and oocName:len() > 0 then
                                    table.insert(selectDisplay, string.format("(%s)", oocName));
                                end

                                local displayName = #selectDisplay > 0 and table.concat(selectDisplay, " ") or "Unknown witness";

                                reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.witnessesTab.args[witnessKey].name = displayName;
                            end
                    },
                    personReportedIncident =
                    {
                        name = "Incident reporter",
                        type = "toggle",
                        width = "normal",
                        order = 2,
                        get =
                            function(info)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.IsIncidentReporter;
                            end,
                        set =
                            function(info, value)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details.IsIncidentReporter = value;
                            end,
                    },
                    personalDescription =
                    {
                        name = "Personal description",
                        type = "input",
                        multiline = 6,
                        width = "full",
                        order = 3,
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
                        desc = "|cff00ffffUse the description builder to help you build descriptive statements of a person either by entering data yourself or auto-populating from the targets TRP profile.|r",
                        width = "full",
                        order = 4,
                        func =
                            function(info)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                reportService:SetDescriptionForSubject(
                                    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details,
                                    reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.witnessesTab.args[witnessKey]);
                            end,
                    },
                    breaker1 =
                    {
                        type = "header",
                        name = "",
                        order = 5,
                    },
                    statement =
                    {
                        name = "Statement",
                        type = "input",
                        multiline = 6,
                        width = "full",
                        order = 6,
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
                        order = 7,
                        desc = "|cff00ffffUse the statement recorder to capture speech and emotes between multiple entities, and then automatically populate the statement field by clicking complete.|r",
                        func =
                            function(info)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                reportService:SetStatementForSubject(
                                    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey].Details);
                            end,
                    },
                    breaker2 =
                    {
                        type = "header",
                        name = "Delete",
                        order = 8,
                    },
                    deleteDescription =
                    {
                        name = "|cffff0000If you need to remove this witness, then you can do so by clicking the button below. Just note that this can't be reversed.|r",
                        type = "description",
                        order = 9,
                    },
                    delete =
                    {
                        type = "execute",
                        name = "Remove this witness",
                        order = 10,
                        width = "full",
                        func = 
                            function(info)
                                local incidentKey = info[#info-4];
                                local witnessKey = info[#info-2];
        
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);
        
                                reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.witnessesTab.args[witnessKey] = nil;
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey] = nil;
                            end
                    }
                }
            },      
        }
    }
    
end

function LEASuite_ReportService.AddWitnessToDb(incidentKey, witnessKey)
    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Witnesses[witnessKey] = {
        Details = {
            FullName = "*New witness",
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
                        local configDialogService = LibStub(LEASuite_Constants.LIB_ACE_CONFIG_DIALOG);
                        local newSuspectKey = reportService:GetNextRandomKey();
                        local incidentKey = info[#info-2];

                        local newDetails = LEASuite_ReportService.AddSuspectToDb(incidentKey, newSuspectKey);                        
                        LEASuite_ReportService.AddSuspectToUi(                            
                            reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.suspectsTab,
                            newSuspectKey,
                            newDetails);
                        configDialogService:SelectGroup(LEASuite_Constants.OPT_ADDON_ID, "incidentReportsTab", incidentKey, "suspectsTab", newSuspectKey, "detailsTab");
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
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.FullName = value;

                                local selectDisplay = {};
                                local fullName = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.FullName;
                                local oocName = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.OocName;

                                if fullName and fullName:len() > 0 then
                                    table.insert(selectDisplay, fullName);
                                end    
                                if oocName and oocName:len() > 0 then
                                    table.insert(selectDisplay, string.format("(%s)", oocName));
                                end

                                local displayName = #selectDisplay > 0 and table.concat(selectDisplay, " ") or "Unknown suspect";

                                reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.suspectsTab.args[suspectKey].name = displayName;
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
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.OocName = value;

                                local selectDisplay = {};
                                local fullName = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.FullName;
                                local oocName = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details.OocName;

                                if fullName and fullName:len() > 0 then
                                    table.insert(selectDisplay, fullName);
                                end    
                                if oocName and oocName:len() > 0 then
                                    table.insert(selectDisplay, string.format("(%s)", oocName));
                                end

                                local displayName = #selectDisplay > 0 and table.concat(selectDisplay, " ") or "Unknown suspect";

                                reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.suspectsTab.args[suspectKey].name = displayName;
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
                        desc = "|cff00ffffUse the description builder to help you build descriptive statements of a person either by entering data yourself or auto-populating from the targets TRP profile.|r",
                        width = "full",
                        order = 3,
                        func =
                            function(info)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                reportService:SetDescriptionForSubject(
                                    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details,
                                    reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.suspectsTab.args[suspectKey]
                                );
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
                        desc = "|cff00ffffUse the statement recorder to capture speech and emotes between multiple entities, and then automatically populate the statement field by clicking complete.|r",
                        order = 6,
                        func =
                            function(info)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                                reportService:SetStatementForSubject(
                                    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Details);
                            end,
                    },
                    breaker2 =
                    {
                        type = "header",
                        name = "Delete",
                        order = 7,
                    },
                    deleteDescription =
                    {
                        name = "|cffff0000If you need to remove this suspect, then you can do so by clicking the button below. Just note that this can't be reversed.|r",
                        type = "description",
                        order = 8,
                    },
                    delete =
                    {
                        type = "execute",
                        name = "Remove this suspect",
                        order = 9,
                        width = "full",
                        func = 
                            function(info)
                                local incidentKey = info[#info-4];
                                local suspectKey = info[#info-2];
        
                                local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);
        
                                reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.suspectsTab.args[suspectKey] = nil;
                                LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey] = nil;
                            end
                    }
                }
            },
            offencesTab = LEASuite_ReportService.AddSuspectOffences(suspectData.Offences)
        }
    }    
end

function LEASuite_ReportService.AddSuspectToDb(incidentKey, suspectKey)
    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey] = {
        Details =
        {
            FullName = "*New suspect",
            OocName = nil,
            PersonalDescription = nil,
            Statement = nil,
        },
        Offences = {}
    };

    return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey];
end

function LEASuite_ReportService.AddSuspectOffences(offenceData)
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
                name = "|cff00ffffOffences and their categories are as per the format of the King's Law.\n\nAdd offences and switch between them using the add offence button below or the dropdown to the right.|r",
                type = "description",
                order = 1,
            },
            addOffenceButton =
            {
                type = "execute",
                name = "Add offence",
                order = 2,
                func =
                    function(info)
                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);
                        local configDialogService = LibStub(LEASuite_Constants.LIB_ACE_CONFIG_DIALOG);
                        local incidentKey = info[#info-4];
                        local suspectKey = info[#info-2];
                        local newOffenceKey = reportService:GetNextRandomKey();
                        
                        local newDetails = LEASuite_ReportService.AddSuspectOffenceToDb(incidentKey, suspectKey, newOffenceKey);                        
                        LEASuite_ReportService.AddSuspectOffenceToUi(                            
                            reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.suspectsTab.args[suspectKey].args.offencesTab,
                            newOffenceKey,
                            newDetails);

                        configDialogService:SelectGroup(LEASuite_Constants.OPT_ADDON_ID, "incidentReportsTab", incidentKey, "suspectsTab", suspectKey, "offencesTab", newOffenceKey);
                    end
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

function LEASuite_ReportService.AddSuspectOffenceToUi(targetDbTable, newOffenceKey, offenceData)

    local offenceService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_OFFENCE_SERVICE);
    
    local offenceName = offenceService:GetOffencesForCategory(offenceData.CategoryId)[offenceData.OffenceId];
    targetDbTable.args[newOffenceKey] = {
        name = offenceName or "*New offence",
        type = "group",
        args =
        {
            offenceCategory =
            {
                type = "select",
                name = "Offence category",
                values = 
                    function()
                        local offenceService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_OFFENCE_SERVICE);
                        return offenceService:GetOffenceCategories();
                    end,
                order = 0,
                width = "full",
                get = 
                    function(info)
                        local incidentKey = info[#info-5];
                        local suspectKey = info[#info-3];
                        local offenceKey = info[#info-1];
                        
                        return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey].CategoryId;
                    end,
                set = 
                    function(info, value)
                        local incidentKey = info[#info-5];
                        local suspectKey = info[#info-3];
                        local offenceKey = info[#info-1];

                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                        local oldValue = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey].CategoryId;
                        
                        if oldValue ~= value then
                            LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey].OffenceId = nil;
                            reportService.OptionsTable.args.incidentReportsTab.args[incidentKey]
                                .args.suspectsTab.args[suspectKey].args.offencesTab.args[offenceKey].name = "*New offence";
                        end

                        LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey].CategoryId = value;
                    end,
            },
            offence =
            {
                type = "select",
                name = "Offence",
                values = 
                    function(info)
                        local incidentKey = info[#info-5];
                        local suspectKey = info[#info-3];
                        local offenceKey = info[#info-1];

                        local offenceService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_OFFENCE_SERVICE);
                        local selectedCategory = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey].CategoryId;

                        return offenceService:GetOffencesForCategory(selectedCategory);
                    end,
                order = 1,
                width = "full",
                get = 
                    function(info)
                        local incidentKey = info[#info-5];
                        local suspectKey = info[#info-3];
                        local offenceKey = info[#info-1];

                        return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey].OffenceId;
                    end,
                set = 
                    function(info, value)
                        local incidentKey = info[#info-5];
                        local suspectKey = info[#info-3];
                        local offenceKey = info[#info-1];

                        local offenceService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_OFFENCE_SERVICE);
                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                        local selectedCategory = LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey].CategoryId;
                        reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.suspectsTab.args[suspectKey].args.offencesTab.args[offenceKey].name
                            = offenceService:GetOffencesForCategory(selectedCategory)[value] or "*New offence";

                        LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey].OffenceId = value;
                    end,
            },
            breaker1 =
            {
                type = "header",
                name = "Delete",
                order = 2,
            },
            deleteDescription =
            {
                name = "|cffff0000If you need to remove this offence, then you can do so by clicking the button below. Just note that this can't be reversed.|r",
                type = "description",
                order = 3,
            },
            delete =
            {
                type = "execute",
                name = "Remove this offence",
                order = 4,
                width = "full",
                func = 
                    function(info)
                        local incidentKey = info[#info-5];
                        local suspectKey = info[#info-3];
                        local offenceKey = info[#info-1];

                        local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

                        reportService.OptionsTable.args.incidentReportsTab.args[incidentKey].args.suspectsTab.args[suspectKey].args.offencesTab.args[offenceKey] = nil;
                        LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey] = nil;
                    end
            }
        }
    }
end

function LEASuite_ReportService.AddSuspectOffenceToDb(incidentKey, suspectKey, offenceKey)
    LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey] = {
        {
            CategoryId = nil,
            OffenceId = nil,
        }
    };

    return LEASuiteAddonDataSettingsDB.char.IncidentReports[incidentKey].Suspects[suspectKey].Offences[offenceKey];
end

function LEASuite_ReportService:SetDescriptionForSubject(descriptionNode, selectionNode)

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


        
        descriptionNode.FullName = #characterFullNameTable > 0 and table.concat(characterFullNameTable, " ");
        descriptionNode.OocName = characterData.UseOocName and characterData.OocName;
        descriptionNode.PersonalDescription = descriptionText;

        local selectDisplay = {};
        if descriptionNode.FullName and descriptionNode.FullName:len() > 0 then
            table.insert(selectDisplay, descriptionNode.FullName);
        end    
        if descriptionNode.OocName and descriptionNode.OocName:len() > 0 then
            table.insert(selectDisplay, string.format("(%s)", descriptionNode.OocName));
        end

        local displayName = #selectDisplay > 0 and table.concat(selectDisplay, " ") or "Unknown witness";

        if selectionNode then
            selectionNode.name = displayName;
        end
        
        LibStub(LEASuite_Constants.LIB_ACE_CONFIG_REGISTRY):NotifyChange(LEASuite_Constants.OPT_ADDON_ID);
    end);

end

function LEASuite_ReportService:SetStatementForSubject(node)

    self._recorderService:ShowRecorderWindow(function(statementText)

        node.Statement = statementText;
        
        LibStub(LEASuite_Constants.LIB_ACE_CONFIG_REGISTRY):NotifyChange(LEASuite_Constants.OPT_ADDON_ID);
    end);

end

function LEASuite_ReportService:ShowLeaSuiteWindow()

    local configDialog = LibStub(LEASuite_Constants.LIB_ACE_CONFIG_DIALOG);

    configDialog:SetDefaultSize(LEASuite_Constants.OPT_ADDON_ID, 850, 750);
    configDialog:Open(LEASuite_Constants.OPT_ADDON_ID);

end

function LEASuite_ReportService:GetNextRandomKey()
    return tostring(date("!%Y%m%d%H%M%S"));
end