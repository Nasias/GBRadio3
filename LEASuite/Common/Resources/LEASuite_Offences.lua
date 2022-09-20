LEASuite_Offences =
{
    {
        Title = "Offences Against the Person",
        Description = "Offences Against the Person are those which involve the threat or use of violence, as well as the infliction of harm. Offences Against the Person also apply to Magic related incidents.",
        Offences =
        {
            {
                Title = "S1. Common Assault",
                Description = "When a person intentionally or recklessly causes another person to suffer unlawful violence, or genuinely believe that they are about to suffer immediate unlawful violence.",
                IsPenaltyOffence = true,
                IsSummaryOffence = false,
                IsIndictableOffence = false,
                AppliesWhen =
                {
                    "A person directly threatens somebody with immediate violence and the victim thinks an attack is imminent.",
                    "A person throws a punch at somebody but they miss.",
                    "A person punches or kicks the victim but leaves minor bruising.",
                },
                NotAppliesWhen =
                {
                    "A person makes a hollow threat of violence.",
                    "A person falls over, accidentally striking someone as they try to brace themselves.",
                    "The victim sustains injuries more severe than those covered by this section. Instead use the higher grade offence.",
                },
                SuggestedPunishments =
                {
                    "5 Silver Fine",
                    "3 Lashes",
                    "1 Day Community Restitution Order",
                }
            },
            {
                Title = "S2. Actual Bodily Harm (ABH)",
                Description = "When a person physically attacks another person, causing injury to that person.",
                IsPenaltyOffence = true,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen =
                {
                    "A person punches or kicks the victim and it leaves a number of superficial bruises.",
                    "A person jabs the victim with a club, leaving behind a large but superficial bruise on their arm.",
                    "A person scratches the victim with their nails, leaving shallow grazing on their cheek.",
                    "A person shoves the victim, causing them to stumble and hit their head against the wall, causing swelling.",
                    "A person intentionally applies unlawful force to the victim, resulting in injury.",
                },
                NotAppliesWhen =
                {
                    "A person swings a club at someone's head but misses.",
                    "The victim sustains injuries more severe than those covered by this section. Instead use the higher grade offence.",
                    "A person accidentally applies force to the victim, resulting in injury; such as tripping over a step and pushing someone in to a wall.",
                },
                SuggestedPunishments =
                {
                    "15 Silver Fine",
                    "6 Lashes",
                    "2 Day Community Restitution Order",
                }
            },
            {
                Title = "S3. Grievous Bodily Harm (GBH)",
                Description = "When a person physically attacks another person, causing a serious injury to that person.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen =
                {
                    "The suspect uses a non-deadly weapon to inflict serious injury to the victim.",
                    "The suspect inflicts deep cuts, broken bones, a fractured skull, injuries that impair vision, motor skills, cognition or cause internal organ damage.",
                },
                NotAppliesWhen =
                {
                    "The suspect uses a deadly weapon in the execution of the offence, and causes serious injury. Instead, consider attempted murder if applicable.",
                    "The suspect stabbed the victim with a dagger or sword and caused serious injury, though the victim survives. Instead, consider attempted murder if applicable.",
                    "The suspect shoots the victim and the victim survives. Instead, consider attempted murder if applicable.",
                },
                SuggestedPunishments =
                {
                    "15 Lashes",
                    "3 Day Community Restitution Order",
                }
            },
            {
                Title = "S4. Threats to Kill",
                Description = "When a person threatens to kill another person, causing that person to genuinely believe that the threat will be carried out.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen =
                {
                    "A person directly threatens someone with murder after losing to them in cards.",
                    "A person threatens to murder another persons partner.",
                    "A person threatens to kill another person during a heated argument.",
                },
                NotAppliesWhen =
                {
                    "A person comments in jest about killing another person after being the recipient of that persons practical joke.",
                    "A person expresses their desire to kill their friend in hollow frustration, after their friend is late to an event.",
                    "There is reasonable doubt that the threat was genuine. Use your best judgement.",
                },
                SuggestedPunishments =
                {
                    "30 silver fine",
                    "15 lashes",
                    "3 Day Community Restitution Order",
                }
            },
            {
                Title = "S5. Kidnapping",
                Description = "When a person unlawfully seizes and/or carries away a person, against their will, by force, or threat of force.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    
                }
            },
        }
    },
    {
        Title = "Offences Against Public Order",
        Description = "Offences Against Public Order are those which happen in a public place; such as on the street or in a tavern, and deal with people acting inappropriately.",
        Offences =
        {
            
            {
                Title = "S1. Causing Harassment, Alarm, or Distress",
                Description = "When a person uses threatening, abusive or insulting words or behaviour, or engages in disorderly behaviour within the hearing or sight of a person who is likely to feel harassment, or to who the behaviour causes alarm or distress thereby.",
                IsPenaltyOffence = true,
                IsSummaryOffence = false,
                IsIndictableOffence = false,
                AppliesWhen = 
                {
                    "A person indecently exposes themselves.",
                    "A person stalks another.",
                    "A person swears excessively and threateningly.",
                    "A person uses veiled or indirect threats.",
                },
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "5 Silver Fine",
                    "1 Day Community Restitution Order",
                }
            },
            {
                Title = "S2. Public Nuisance",
                Description = "When a person exhibits disorderly behaviour which disrupts order or the King's peace, or outrages public decency.",
                IsPenaltyOffence = true,
                IsSummaryOffence = false,
                IsIndictableOffence = false,
                AppliesWhen = 
                {
                    "A person conducts themselves in such a way that it outrages public decency.",
                    "A person shouts excessively.",
                    "A person engages in verbal abuse of another.",
                    "A person is drunk and disorderly.",
                    "A person engages in anti-social behavior.",
                },
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "5 Silver Fine",
                    "1 Day Community Restitution Order",
                }
            },
            {
                Title = "S3. Affray",
                Description = "When a person uses or threatens to use unlawful violence towards another person and with such conduct as would cause a person of reasonable firmness present at the scene to fear for their personal safety.",
                IsPenaltyOffence = true,
                IsSummaryOffence = false,
                IsIndictableOffence = false,
                AppliesWhen = 
                {
                    "A person fights in a public place that isn't designated for combat.",
                },
                NotAppliesWhen = 
                {
                    "A person fights with another in a private dwelling.",
                    "A person fights with another in an organised and sanctioned event.",
                },
                SuggestedPunishments =
                {
                    "5 Silver Fine",
                    "1 Day Community Restitution Order",
                }
            },
            {
                Title = "S4. Public Endangerment",
                Description = "When a person acts or conducts themselves in such a manner, that is creates a substantial risk of physical injury to others in a public place.",
                IsPenaltyOffence = true,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen =
                {
                    "A person walks around with a loaded firearm in their hands.",
                    "A person plants any number of explosives with the intention to do harm.",
                    "A person recklessly rides through a crowd on a warhorse. ",
                },
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "15 Silver Fine",
                    "6 Lashes",
                    "2 Day Community Restitution Order",
                }
            },
            {
                Title = "S5. Violent Disorder",
                Description = "When a person belongs to a group of three (3) or more people, who are present together, and use or to threaten to use unlawful violence.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "12 Lashes",
                    "3 Day Community Restitution Order",
                }
            },
            {
                Title = "S6. Riot",
                Description = "Belonging to a group of five (5) or more people who are present together to use or to threaten unlawful violence for a common purpose.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "18 Lashes",
                }
            },
            {
                Title = "S7. Violating a Barring Order",
                Description = "When a person enters the City of Stormwind while under the effects of an active barring order.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen = {
                    "A person has been issued a barring order and is in the City of Stormwind before it has expired.",
                    "A person belonging to an organisation under the effects of an active barring order.",
                },
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "10 Lashes",
                    "Ejection from the City of Stormwind",
                }
            },
        }
    },
    {
        Title = "Offences Against Property",
        Description = "Offences Against Property are those which relate to the illegal acquisition of goods or criminal damage to property.",
        Offences =
        {
            {
                Title = "S1. Theft",
                Description = "When a person steals money or property.",
                IsPenaltyOffence = true,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "5 Silver Fine",
                    "1 Day Community Restitution Order",
                    "Mandatory return of the stolen property, or cash value if not possible.",
                }
            },
            {
                Title = "S2. Robbery",
                Description = "When a person threatens to use, or directly uses violence against another person while stealing their money or property from them.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "6 Lashes",
                    "2 Day Community Restitution Order",
                    "Mandatory return of the stolen property, or cash value if not possible.",
                }
            },
            {
                Title = "S3. Banditry",
                Description = "When a person engages in organised acts of robbery while part of a group of three or more people.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "12 Lashes",
                    "3 Day Community Restitution Order",
                    "Mandatory return of the stolen property, or cash value if not possible.",
                }
            },
            {
                Title = "S4. Trespassing",
                Description = "When a person enters the building of another, or public office, without right or permission.",
                IsPenaltyOffence = true,
                IsSummaryOffence = false,
                IsIndictableOffence = false,
                AppliesWhen = 
                {
                    "A person refuses to vacate the property when told to leave.",
                    "A person enters a property with malicious intent, whether they knew it was private or not.",
                },
                NotAppliesWhen =                 
                {
                    "A person enters property, where a reasonable person would believe that the property was not private or closed, and leaves when asked to do so.",
                },
                SuggestedPunishments =
                {
                    "5 Silver Fine",
                    "3 Lashes",
                }
            },
            {
                Title = "S5. Trading Stolen Property",
                Description = "When a person knowingly purchases or sells stolen property.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen =
                {
                    "A person can prove that they were not aware that the property was stolen.",
                },
                SuggestedPunishments =
                {
                    "6 Lashes",
                }
            },
            {
                Title = "S6. Fraud",
                Description = "When a person engages in acts of deceit that are liable to cause financial, physical or intellectual damage.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "6 Lashes",
                }
            },
            {
                Title = "S7. Destruction of Property",
                Description = "When a person wilfully damages or destroys the property of another person without permission.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "6 Lashes",
                    "Reimbursement for the damage caused.",
                }
            },
            {
                Title = "S8. Destruction of Public Property",
                Description = "When a person wilfully damages or destroys the property of the Crown without permission.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "6 Lashes",
                    "Reimbursement for the damage caused.",
                }
            },
            {
                Title = "S9. Sabotage",
                Description = "When a person wilfully damages or destroys weapons, equipment or supplies belonging to the Crown.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "12 Lashes",
                }
            },
        }
    },
    {
        Title = "Offences Against the Use of Magic",
        Description = "Offences Against the Use of Magic are those which relate to the crimimal, improper or unsanctioned use of magic.",
        Offences =
        {
            {
                Title = "S1. Misuse of Magic",
                Description = "When a person uses any type of magic in the execution of a criminal offence.",
                IsPenaltyOffence = true,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "15 Silver Fine",
                    "6 Lashes",
                }
            },
            {
                Title = "S2. Unsanctioned Practice of Forbidden Magic",
                Description = "When a person casts a spell or enchantment of a forbidden type without being sanctioned to do so.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "15 Silver Fine",
                    "6 Lashes",
                }
            },
            {
                Title = "S3. Unsanctioned Mental Invasion",
                Description = "When a person breaches the mind of a person without being sanctioned to do so. A person is allowed to enter the mind of another if consent is given.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "12 Lashes",
                }
            },
            {
                Title = "S4. Unsanctioned Appearance of a Familiar",
                Description = "When a person allows a controlled familiar to take on a form that is larger than 6ft tall, 6f wide, obscene or distasteful, or that of a fully sentient being, without being sanctioned to do so.",
                IsPenaltyOffence = true,
                IsSummaryOffence = false,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "15 Silver Fine",
                }
            },
            {
                Title = "S5. Inadequate Familiar Identification",
                Description = "When a person allows a controlled familiar to take form without a seal or symbol of its summoner/controller, or a false seal or symbol.",
                IsPenaltyOffence = true,
                IsSummaryOffence = false,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "5 Silver Fine",
                }
            },
            {
                Title = "S6. Summoning of a Demon",
                Description = "When a person casts a spell or ritual which results in a demonic entity taking form in the mortal realm.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "12 Lashes",
                }
            },
            {
                Title = "S7. Unsanctioned Teleportation and Portal Manifestation",
                Description = "When a person; uses teleportation magic to enter the City of Stormwind without passing through the mage tower's teleportation anchor without sanction, or; opens a portal to an unauthorised drop-off zone without Special Issue License D-6, or; opens a portal larger than 3 yards, 1 foot, 3 and 3/4 inches tall, 2 yards, 8 feet, 9 and 15/16 inches wide without Special Issue License G-16, or; disposes of solids, liquids gasses or plasma using portals or teleportation magic without sanction.",
                IsPenaltyOffence = true,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "15 Silver Fine",
                    "2 Day Community Restitution Order",
                }
            },
            {
                Title = "S8. Unlawful Use and Exploitation of Conjuration",
                Description = "When a person conjures coins that resemble the sovereign currency, conjures objects for sale or exchange, where the vendor has mislead the purchaser to believe they are not conjured, conjures an object for use in a criminal act, or conjures a deadly object or substance.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "30 Silver Fine",
                    "12 Lashes",
                    "3 Day Community Restitution Order",
                }
            },
            {
                Title = "S9. Unlawful Use of Transmutation",
                Description = "When a person; polymorphs an individual in to a complex creature, or; polymorphs a low intelligence creature into a high intelligence creature, or; transmutes a living biological entity in to a non-living material, or; transmutes multiple creatures in to a single creature, or; transmutes materials in to other materials, without a transmutation hallmark on the new material, or; performs physiological transmutation on a person without permission and without qualification.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "15 Silver Fine",
                    "6 Lashes",
                    "2 Day Community Restitution Order",
                }
            },
        }
    },
    {
        Title = "Capital Offences",
        Description = "Capital Offences are those which have the potential to have a deep impact on a community or society at large.",
        Offences =
        {
            {
                Title = "S1. Murder",
                Description = "When a person of sound mind and discretion unlawfully kills any person in being under the King's Peace with intent to kill or cause grievous bodily harm (GBH).",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "18 Lashes",
                    "1 Week Civil Death",
                    "Execution",
                }
            },
            {
                Title = "S2. Capital Murder",
                Description = "When a person of sound mind and discretion unlawfully kills; a Soldier; a Guard or a Security and Intelligence Agent with intent to kill or cause grievous bodily harm (GBH).",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "18 Lashes",
                    "1 Week Civil Death",
                    "Execution",
                }
            },
            {
                Title = "S3. Assassination",
                Description = "When a person of sound mind and discretion unlawfully kills; a Magistrate; a Judge; a Prosecutor; a Religious or Political Figure; a Military Officer, or; a Security and Intelligence Officer with intent to kill or cause grievous bodily harm (GBH).",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "24 Lashes",
                    "2 Weeks Civil Death",
                    "Execution",
                }
            },
            {
                Title = "S4. Involuntary Manslaughter",
                Description = "When a person negligently or recklessly causes the unlawful death of another.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {"",
                    "12 Lashes",
                    "5 Day Community Restitution Order",
                }
            },
            {
                Title = "S5. Voluntary Manslaughter",
                Description = "When a person knowingly or intentionally causes the unlawful death of another after reasonable provocation.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "12 Lashes",
                    "3 Day Civil Death",
                }
            },
            {
                Title = "S6. Misconduct in Public Office",
                Description = "When a person acting in a public office, performs an act that is harmful, legally unjustified and contrary to law.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "30 Silver Fine",
                    "12 Lashes",
                    "3 Day Civil Death",
                }
            },
            {
                Title = "S7. Theft of Information",
                Description = "When a person steals confidential information from a Law Enforcement entity, Court of Law officials, the Military or Intelligence Services.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {                   
                    "60 Silver Fine",
                    "18 Lashes",
                    "5 Day Community Restitution Order",
                }
            },
            {
                Title = "S8. Misuse of Information",
                Description = "When a person spreads confidential information to another person who is unauthorised to see it.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "60 Silver Fine",
                    "18 Lashes",
                    "5 Day Community Restitution Order",
                }
            },
            {
                Title = "S9. Treason",
                Description = "When a person acts in such a way that they attempt to overthrow one's government, or to harm or kill its sovereign.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "24 Lashes",
                    "1 Week Civil Death",
                    "Execution",
                }
            },
            {
                Title = "S10. Torture",
                Description = "When a person inflicts severe pain of body or mind upon another person.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "18 Lashes",
                    "1 Week Civil Death",
                }
            },
            {
                Title = "S11. Impersonation",
                Description = "When a person deceptively acts or conducts themselves for the purposes of fraud in such a way that it may cause a reasonable person to believe that the perpetrator is a different person.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments = {}
            },
        }
    },
    {
        Title = "Offences Against Goods and Trade",
        Description = "Offences Against Goods and Trade are those which relate to the illegal possession, distribution or manufacture of articles classified under the Goods and Trade Controlled Articles provisions.",
        Offences =
        {
            {
                Title = "S1. Possession of a Class-A Controlled Article",
                Description = "When a person carries a Class-A controlled article.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "15 Silver Fine",
                    "6 Lashes",
                    "2 Day Community Restitution Order",
                }
            },
            {
                Title = "S2. Distribution of a Class-A Controlled Article",
                Description = "When a person sells or distributes a Class-A controlled article.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "30 Silver Fine",
                    "12 Lashes",
                }
            },
            {
                Title = "S3. Manufacture of a Class-A Controlled Article",
                Description = "When a person manufactures, produces or grows a Class-A controlled article.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "60 Silver Fine",
                    "18 Lashes",
                }
            },
            {
                Title = "S4. Possession of a Class-B Controlled Article",
                Description = "When a person carries a Class-B controlled article.",
                IsPenaltyOffence = true,
                IsSummaryOffence = false,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "5 Silver Fine",
                    "3 Lashes",
                    "1 Day Community Restitution Order",
                }
            },
            {
                Title = "S5. Distribution of a Class-B Controlled Article",
                Description = "When a person sells or distributes a Class-B controlled article.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "15 Silver Fine",
                    "6 Lashes",
                }
            },
            {
                Title = "S6. Manufacture of a Class-B Controlled Article",
                Description = "When a person manufactures, produces or grows a Class-B controlled article.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "30 Silver Fine",
                    "12 Lashes",
                }
            },
            {
                Title = "S7. Possession of a Forged Article",
                Description = "When a person carries a forged copy of a document, signature, money or other item of value for unlawful purposes.",
                IsPenaltyOffence = true,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "5 Silver Fine",
                    "3 Lashes",
                    "1 Day Community Restitution Order",
                }
            },
            {
                Title = "S8. Distribution of a Forged Article",
                Description = "When a person distributes a forged copy of a document, signature, money or other item of value for unlawful purposes.",
                IsPenaltyOffence = true,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen = 
                {
                    "A person knowingly sells a forged article.",
                    "A person hands out forged articles to others.",
                    "A person knowingly uses a forged article, in the execution of its original purpose.",
                },
                NotAppliesWhen =
                {
                    "A person sells a forged article and can prove they were unaware it was a forgery.",
                    "A person uses a forged article, in the execution of its original purpose, and can prove that they were unaware it was a forgery.",
                },
                SuggestedPunishments =
                {
                    "15 Silver Fine",
                    "6 Lashes",
                    "2 Day Community Restitution Order",
                }
            },
            {
                Title = "S9. Manufacture of a Forged Article",
                Description = "When a person manufactures a forged copy of a document, signature, money or other item of value for unlawful purposes.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "30 Silver Fine",
                    "12 Lashes",
                }
            },
            {
                Title = "S10. Smuggling",
                Description = "When a person transports or ships a controlled article.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    
                }
            },
        }
    },
    {
        Title = "Offences of Organised Crime",
        Description = "Offences of Organised Crime are those which relate to organisations that engage in criminal activity, their members, and individuals who support criminal organisations engaging in organised crime.",
        Offences =
        {
            {
                Title = "S4. Membership in a Proscribed Organisation",
                Description = "When a person belongs or professes to belong to a proscribed organisation.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "100 Silver Fine",
                    "24 Lashes",
                    "Capital Punishment",
                }
            },
            {
                Title = "S5. Supporting a Proscribed Organisation",
                Description = "When a person invites support for a proscribed organisation, intentionally or knowingly assists or further the goals of a proscribed organisation in the commission of its activities directly or indirectly through their actions, or wears an item of clothing, wears, carries or displays an article that is affiliated with a proscribed organisation.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "30 Silver Fine",
                    "12 Lashes",
                }
            },
        }
    },
    {
        Title = "Supporting Offences",
        Description = "Supporting Offences are those which supplement the severity of other offences.",
        Offences =
        {
            {
                Title = "Attempted Offence",
                Description = "An attempt takes place when a person commits an act which is more than merely preparatory for the commission of the full offence.",
                IsPenaltyOffence = true,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "Sentence according to the severity of the base offence"
                }
            },
            {
                Title = "Collusion",
                Description = "When a person knows of a plan to commit a criminal act but fails to report it to Law Enforcement.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    
                }
            },
            {
                Title = "Failure to Report",
                Description = "When a person has knowledge of a criminal act but fails to report it to Law Enforcement.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = false,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "5 Silver Fine",
                    "3 Lashes",
                }
            },
            {
                Title = "Accessory",
                Description = "When a person assists in the commission of a offence.",
                IsPenaltyOffence = true,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "Sentence according to the severity of the base offence"
                }
            },
            {
                Title = "Obstructing a Constable",
                Description = "Resisting or wilfully obstructing a law enforcement officer in the execution of their duty.",
                IsPenaltyOffence = true,
                IsSummaryOffence = false,
                IsIndictableOffence = false,
                AppliesWhen = 
                {
                    "A person refuses to remove themselves from an area, when lawfully ordered to do so be a constable.",
                },
                NotAppliesWhen =
                {
                    "A person is ordered to remove themselves from an area by a constable, when the area has no immediate or near-immediate interest to law enforcement organisations.",
                },
                SuggestedPunishments =
                {
                    "6 Lashes",
                    "2 Day Community Restitution Order",
                }
            },
            {
                Title = "Obstruction of Justice",
                Description = "Interfering or obstructing Law enforcement officers in their lawful duties.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "6 Lashes"
                }
            },
            {
                Title = "Perverting the Course of Justice",
                Description = "When an accused person does an act or series of acts which has or have a tendency to pervert and which is or are intended to pervert the course of public justice.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen =
                {
                    "When a person knowingly and purposely makes a false statement to a guard",
                    "When a person uses documents with the intent to deceive.",
                },
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "12 Lashes"
                }
            },
            {
                Title = "Absconding",
                Description = "When a person escapes or prepares to escape from lawful custody.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = 
                {
                    "A person breaks out of a jail cell.",
                    "A person has been arrested, but flees custody while en route to a jail cell.",
                },
                NotAppliesWhen =
                {
                    "A person runs away from guards before they are arrested and taken in to custody.",
                },
                SuggestedPunishments =
                {
                    "12 Lashes"
                }
            },
            {
                Title = "Evasion of Justice",
                Description = "When a person escapes or attempts to escape from one's lawful punishment for an offence.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = 
                {
                    "When a person has been granted bail, but leaves the city and goes in to hiding before completing their sentence.",
                },
                NotAppliesWhen = 
                {
                    "When a person runs away from guards before being arrested and being taken in to custody."
                },
                SuggestedPunishments =
                {
                    "12 Lashes"
                }
            },
            {
                Title = "Perjury",
                Description = "Knowingly making false statement during a Court in session or to a Magistrate and/or Judge directly.",
                IsPenaltyOffence = false,
                IsSummaryOffence = false,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    "12 Lashes"
                }
            },
            {
                Title = "Harboring a Criminal",
                Description = "When a person affords lodging to, shelters, or gives refuge to a criminal and/or suspected criminal.",
                IsPenaltyOffence = false,
                IsSummaryOffence = true,
                IsIndictableOffence = true,
                AppliesWhen = {},
                NotAppliesWhen = {},
                SuggestedPunishments =
                {
                    
                }
            },
        }
    }
};