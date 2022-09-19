LEASuite_CharacterDescriptionService = LEASuite_Object:New();

function LEASuite_CharacterDescriptionService:New(obj)

    self._aceGUI = LibStub(LEASuite_Constants.LIB_ACE_GUI);
    self.CharacterData = {};
    self.Widgets =
    {
        DescriptionBuilderFrame = nil,
    };

    return self:RegisterNew(obj);

end

function LEASuite_CharacterDescriptionService:UseCharacterData(use, value)
    return use and value and value:len() > 0;
end

function LEASuite_CharacterDescriptionService:BuildDescriptionMatrixText(characterData)

    local description = "";

    if self:UseCharacterData(characterData.UseRace, characterData.Race)
        and self:UseCharacterData(characterData.UseSex, characterData.Sex)
        and self:UseCharacterData(characterData.UseAge, characterData.Age) then

        description = string.format(
            "The subject is a %s %s,", characterData.Race, characterData.Sex);

    elseif self:UseCharacterData(characterData.UseRace, characterData.Race) then

        description = string.format("The subject is a %s,", characterData.Race);

    elseif self:UseCharacterData(characterData.UseSex, characterData.Sex) then
              
        description = string.format("The subject is a %s,", characterData.Sex);

    else
        description = string.format("The subject is of unknown race and sex,", characterData.Sex);
    end
        
    if self:UseCharacterData(characterData.UseAge, characterData.Age) then
        description = description .. string.format(" aged around %s.", characterData.Age);
    else
        description = description .. " of unknown age.";
    end

    if self:UseCharacterData(characterData.UseTitle, characterData.Title)
        or self:UseCharacterData(characterData.UseFirstName, characterData.FirstName)
        or self:UseCharacterData(characterData.UseLastName, characterData.LastName) then

            description = description .. "\n\nThe subject goes by the name of";

            if self:UseCharacterData(characterData.UseTitle, characterData.Title) then
                description = description .. string.format(" %s", characterData.Title);
            end

            if self:UseCharacterData(characterData.UseFirstName, characterData.FirstName) then
                description = description .. string.format(" %s", characterData.FirstName);
            end

            if self:UseCharacterData(characterData.UseLastName, characterData.LastName) then
                description = description .. string.format(" %s", characterData.LastName);
            end
            
            description = description .. ",";

    else
        description = description .. "\n\nThe subject's name is not currently known,";
    end

    if self:UseCharacterData(characterData.UseResidence, characterData.Residence) then
        description = description .. string.format(" and is thought to reside in %s.", characterData.Residence);
    else
        description = description .. " and their place of residence is unknown.";
    end

    description = description .. "\n\nThe subject has";

    if self:UseCharacterData(characterData.UseHair, characterData.Hair) then
        description = description .. string.format(" %s hair,", characterData.Hair);
    else
        description = description .. " an unknown hair style,";
    end

    if self:UseCharacterData(characterData.UseEyeColour, characterData.EyeColour) then
        description = description .. string.format(" %s eyes,", characterData.EyeColour);
    else
        description = description .. " an unknown eye colour,";
    end

    if self:UseCharacterData(characterData.UseBodyShape, characterData.BodyShape) then
        description = description .. string.format(" a %s build,", characterData.BodyShape);
    else
        description = description .. " an unknown build,";
    end

    if self:UseCharacterData(characterData.UseHeight, characterData.Height) then
        description = description .. string.format(" and is %s in height.", characterData.Height);
    else
        description = description .. " and an unknown height.";
    end

    if self:UseCharacterData(characterData.UseClothingWorn, characterData.ClothingWorn) then
        description = description .. string.format("\n\nThey were last seen wearing %s,", characterData.ClothingWorn);
    else
        description = description .. "\n\nIt is not known what they were last wearing,"
    end

    if self:UseCharacterData(characterData.UseItemsCarried, characterData.ItemsCarried) then
        description = description .. string.format(" while carrying %s.", characterData.ItemsCarried);
    else
        description = description .. " and it is not known what they were last seen carrying.";
    end

    if self:UseCharacterData(characterData.UseOtherFeatures, characterData.OtherFeatures) then
        description = description .. string.format("\n\nOther notable features include %s.", characterData.OtherFeatures);
    else
        description = description .. "\n\nThere are no other notable features.";
    end

    return description;

end

function LEASuite_CharacterDescriptionService:ShowDescriptionBuilder(callbackFunc)

    self:_buildDescriptionBuilderFrame(callbackFunc);
    self:_clearDetailsFromWindow();

end

function LEASuite_CharacterDescriptionService:_clearDetailsFromWindow()
    local frame = self.Widgets.DescriptionBuilderFrame;

    frame:GetUserData("oocNameText"):SetText("");
    frame:GetUserData("oocNameCheckBox"):SetValue(false);
    self.CharacterData.OocName = nil;
    self.CharacterData.UseOocName = false;

    frame:GetUserData("firstNameText"):SetText("");
    frame:GetUserData("firstNameCheckBox"):SetValue(false);
    self.CharacterData.FirstName = nil;
    self.CharacterData.UseFirstName = false;

    frame:GetUserData("titleText"):SetText("");
    frame:GetUserData("titleCheckBox"):SetValue(false);
    self.CharacterData.Title = nil;
    self.CharacterData.UseTitle = false;

    frame:GetUserData("firstNameText"):SetText("");
    frame:GetUserData("firstNameCheckBox"):SetValue(false);
    self.CharacterData.FirstName = nil;
    self.CharacterData.UseFirstName = false;

    frame:GetUserData("lastNameText"):SetText("");
    frame:GetUserData("lastNameCheckBox"):SetValue(false);
    self.CharacterData.LastName = nil;
    self.CharacterData.UseLastName = false;

    frame:GetUserData("sexText"):SetText("");
    frame:GetUserData("sexCheckBox"):SetValue(false);
    self.CharacterData.Sex = nil;
    self.CharacterData.UseSex = false;

    frame:GetUserData("residenceText"):SetText("");
    frame:GetUserData("residenceCheckBox"):SetValue(false);
    self.CharacterData.Residence = nil;
    self.CharacterData.UseResidence = false;

    frame:GetUserData("raceText"):SetText("");
    frame:GetUserData("raceCheckBox"):SetValue(false);
    self.CharacterData.Race = nil;
    self.CharacterData.UseRace = false;

    frame:GetUserData("ageText"):SetText("");
    frame:GetUserData("ageCheckBox"):SetValue(false);
    self.CharacterData.Age = nil;
    self.CharacterData.UseAge = false;

    frame:GetUserData("eyeColourText"):SetText("");
    frame:GetUserData("eyeColourCheckBox"):SetValue(false);
    self.CharacterData.EyeColour = nil;
    self.CharacterData.UseEyeColour = false;

    frame:GetUserData("heightText"):SetText("");
    frame:GetUserData("heightCheckBox"):SetValue(false);
    self.CharacterData.Height = nil;
    self.CharacterData.UseHeight = false;

    frame:GetUserData("bodyShapeText"):SetText("");
    frame:GetUserData("bodyShapeCheckBox"):SetValue(false);
    self.CharacterData.BodyShape = nil;
    self.CharacterData.UseBodyShape = false;

    frame:GetUserData("hairText"):SetText("");
    frame:GetUserData("hairCheckBox"):SetValue(false);
    self.CharacterData.Hair = nil;
    self.CharacterData.UseHair = false;

    frame:GetUserData("clothingWornText"):SetText("");
    frame:GetUserData("clothingWornCheckBox"):SetValue(false);
    self.CharacterData.ClothingWorn = nil;
    self.CharacterData.UseClothingWorn = false;

    frame:GetUserData("itemsCarriedText"):SetText("");
    frame:GetUserData("itemsCarriedCheckBox"):SetValue(false);
    self.CharacterData.ItemsCarried = nil;
    self.CharacterData.UseItemsCarried = false;

    frame:GetUserData("otherFeaturesText"):SetText("");
    frame:GetUserData("otherFeaturesCheckBox"):SetValue(false);
    self.CharacterData.OtherFeatures = nil;
    self.CharacterData.UseOtherFeatures = false;
end

function LEASuite_CharacterDescriptionService:_applyDescriptionDetailsToWindow(descriptionObject)

    local frame = self.Widgets.DescriptionBuilderFrame;

    if not frame then return end;

    -- OOC Name    
    if descriptionObject._CUSTOM_CN then
        frame:GetUserData("oocNameText"):SetText(descriptionObject._CUSTOM_CN);
        frame:GetUserData("oocNameCheckBox"):SetValue(true);
        self.CharacterData.OocName = descriptionObject._CUSTOM_CN;
        self.CharacterData.UseOocName = true;
    end

    -- Title
    if descriptionObject.TI then
        frame:GetUserData("titleText"):SetText(descriptionObject.TI);
        frame:GetUserData("titleCheckBox"):SetValue(true);
        self.CharacterData.Title = descriptionObject.TI;
        self.CharacterData.UseTitle = true;
    end

    -- First name
    if descriptionObject.FN then
        frame:GetUserData("firstNameText"):SetText(descriptionObject.FN);
        frame:GetUserData("firstNameCheckBox"):SetValue(true);
        self.CharacterData.FirstName = descriptionObject.FN;
        self.CharacterData.UseFirstName = true;
    end

    -- last name
    if descriptionObject.LN then
        frame:GetUserData("lastNameText"):SetText(descriptionObject.LN);
        frame:GetUserData("lastNameCheckBox"):SetValue(true);
        self.CharacterData.LastName = descriptionObject.LN;
        self.CharacterData.UseLastName = true;
    end

    -- Sex
    if descriptionObject._CUSTOM_SE then
        frame:GetUserData("sexText"):SetText(descriptionObject._CUSTOM_SE);
        frame:GetUserData("sexCheckBox"):SetValue(true);
        self.CharacterData.Sex = descriptionObject._CUSTOM_SE;
        self.CharacterData.UseSex = true;
    end

    -- Residence
    if descriptionObject.RE then
        frame:GetUserData("residenceText"):SetText(descriptionObject.RE);
        frame:GetUserData("residenceCheckBox"):SetValue(true);
        self.CharacterData.Residence = descriptionObject.RE;
        self.CharacterData.UseResidence = true;
    end

    -- Race
    if descriptionObject.RA then
        frame:GetUserData("raceText"):SetText(descriptionObject.RA);
        frame:GetUserData("raceCheckBox"):SetValue(true);
        self.CharacterData.Race = descriptionObject.RA;
        self.CharacterData.UseRace = true;
    end

    -- Age
    if descriptionObject.AG then
        frame:GetUserData("ageText"):SetText(descriptionObject.AG);
        frame:GetUserData("ageCheckBox"):SetValue(true);
        self.CharacterData.Age = descriptionObject.AG;
        self.CharacterData.UseAge = true;
    end

    -- Eye colour
    if descriptionObject.EC then
        frame:GetUserData("eyeColourText"):SetText(descriptionObject.EC);
        frame:GetUserData("eyeColourCheckBox"):SetValue(true);
        self.CharacterData.EyeColour = descriptionObject.EC;
        self.CharacterData.UseEyeColour = true;
    end

    -- Height
    if descriptionObject.HE then
        frame:GetUserData("heightText"):SetText(descriptionObject.HE);
        frame:GetUserData("heightCheckBox"):SetValue(true);
        self.CharacterData.Height = descriptionObject.HE;
        self.CharacterData.UseHeight = true;
    end

    -- Body shape
    if descriptionObject.WE then
        frame:GetUserData("bodyShapeText"):SetText(descriptionObject.WE);
        frame:GetUserData("bodyShapeCheckBox"):SetValue(true);
        self.CharacterData.BodyShape = descriptionObject.WE;
        self.CharacterData.UseBodyShape = true;
    end

end

function LEASuite_CharacterDescriptionService:_buildDescriptionBuilderFrame(callbackFunc)

    local descriptionBuilderFrame = self._aceGUI:Create("Window");
    descriptionBuilderFrame:SetCallback("OnClose", function(widget)
        local aceGUI = LibStub(LEASuite_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);

    descriptionBuilderFrame.frame:Raise();
    self.Widgets.DescriptionBuilderFrame = descriptionBuilderFrame;

    descriptionBuilderFrame:SetLayout("Flow");
    descriptionBuilderFrame:SetHeight(730);
    descriptionBuilderFrame:SetWidth(500);
    descriptionBuilderFrame:EnableResize(false);
    descriptionBuilderFrame:SetTitle("Description Builder");

    local descriptionGroup = self._aceGUI:Create("InlineGroup");
    descriptionGroup:SetTitle("");
    descriptionGroup:SetRelativeWidth(1);
    descriptionBuilderFrame:AddChild(descriptionGroup);

    local descriptionBuilderDescription = self._aceGUI:Create("Label");
    descriptionBuilderDescription:SetText("|cff00ffffBuild dynamic subject descriptions by selecting auto generated features based off of your targets TRP profile."
    .. " For subjects where details are not meant to be known, deselect the property by unchecking its respective checkbox,"
    .. "\n\nNote: Not all properties can be auto generated and some may be missing from the target. These can be supplied manually below.\n\n|r");
    descriptionBuilderDescription:SetRelativeWidth(1);
    descriptionGroup:AddChild(descriptionBuilderDescription);

    local autofillFromTrpButton = self._aceGUI:Create("Button");
    autofillFromTrpButton:SetText("Auto-fill from target's TRP");
    autofillFromTrpButton:SetRelativeWidth(1);
    autofillFromTrpButton:SetDisabled(not TRP3_API);
    autofillFromTrpButton:SetCallback("OnClick", function()
        local charDescSrv = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_CHARACTER_DESCRIPTION_SERVICE);
        local mrpSrv = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_MRP_SERVICE);
        
        local targetProfile = mrpSrv:GetTargetProfile();

        if targetProfile then
            charDescSrv:_clearDetailsFromWindow();
            charDescSrv:_applyDescriptionDetailsToWindow(targetProfile);
        end        
    end);
    descriptionGroup:AddChild(autofillFromTrpButton);

    local clearButton = self._aceGUI:Create("Button");
    clearButton:SetText("Clear all fields");
    clearButton:SetRelativeWidth(1);
    clearButton:SetCallback("OnClick", function()
        local charDescSrv = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_CHARACTER_DESCRIPTION_SERVICE);
        charDescSrv:_clearDetailsFromWindow();
    end);
    descriptionGroup:AddChild(clearButton);    

    local basicDetailsGroup = self._aceGUI:Create("InlineGroup");
    basicDetailsGroup:SetTitle("Basic details");
    basicDetailsGroup:SetRelativeWidth(1);
    basicDetailsGroup:SetLayout("Flow");
    descriptionBuilderFrame:AddChild(basicDetailsGroup);

    local oocNameText = self._aceGUI:Create("EditBox");
    oocNameText:SetRelativeWidth(0.5);
    oocNameText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.OocName = text;
    end);
    basicDetailsGroup:AddChild(oocNameText);
    descriptionBuilderFrame:SetUserData("oocNameText", oocNameText);

    local oocNameCheckBox = self._aceGUI:Create("CheckBox");
    oocNameCheckBox:SetValue(false);
    oocNameCheckBox:SetLabel("OOC Name");
    oocNameCheckBox:SetRelativeWidth(0.5);
    oocNameCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseOocName = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("oocNameCheckBox", oocNameCheckBox);
    basicDetailsGroup:AddChild(oocNameCheckBox);

    local titleText = self._aceGUI:Create("EditBox");
    titleText:SetRelativeWidth(0.5);
    titleText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.Title = text;
    end);
    basicDetailsGroup:AddChild(titleText);
    descriptionBuilderFrame:SetUserData("titleText", titleText);

    local titleCheckBox = self._aceGUI:Create("CheckBox");
    titleCheckBox:SetValue(false);
    titleCheckBox:SetLabel("Title");
    titleCheckBox:SetRelativeWidth(0.5);
    titleCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseTitle = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("titleCheckBox", titleCheckBox);
    basicDetailsGroup:AddChild(titleCheckBox);

    local firstNameText = self._aceGUI:Create("EditBox");
    firstNameText:SetRelativeWidth(0.5);
    firstNameText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.FirstName = text;
    end);
    basicDetailsGroup:AddChild(firstNameText);
    descriptionBuilderFrame:SetUserData("firstNameText", firstNameText);

    local firstNameCheckBox = self._aceGUI:Create("CheckBox");
    firstNameCheckBox:SetValue(false);
    firstNameCheckBox:SetLabel("First name");
    firstNameCheckBox:SetRelativeWidth(0.5);
    firstNameCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseFirstName = isChecked;
    end);
    basicDetailsGroup:AddChild(firstNameCheckBox);
    descriptionBuilderFrame:SetUserData("firstNameCheckBox", firstNameCheckBox);

    local lastNameText = self._aceGUI:Create("EditBox");
    lastNameText:SetRelativeWidth(0.5);
    lastNameText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.LastName = text;
    end);
    basicDetailsGroup:AddChild(lastNameText);
    descriptionBuilderFrame:SetUserData("lastNameText", lastNameText);

    local lastNameCheckBox = self._aceGUI:Create("CheckBox");
    lastNameCheckBox:SetValue(false);
    lastNameCheckBox:SetLabel("Last name");
    lastNameCheckBox:SetRelativeWidth(0.5);
    lastNameCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseLastName = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("lastNameCheckBox", lastNameCheckBox);
    basicDetailsGroup:AddChild(lastNameCheckBox);

    local sexText = self._aceGUI:Create("EditBox");
    sexText:SetRelativeWidth(0.5);
    sexText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.Sex = text;
    end);
    basicDetailsGroup:AddChild(sexText);
    descriptionBuilderFrame:SetUserData("sexText", sexText);

    local sexCheckBox = self._aceGUI:Create("CheckBox");
    sexCheckBox:SetValue(false);
    sexCheckBox:SetLabel("Sex");
    sexCheckBox:SetRelativeWidth(0.5);
    sexCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseSex = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("sexCheckBox", sexCheckBox);
    basicDetailsGroup:AddChild(sexCheckBox);

    local residenceText = self._aceGUI:Create("EditBox");
    residenceText:SetRelativeWidth(0.5);
    residenceText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.Residence = text;
    end);
    basicDetailsGroup:AddChild(residenceText);
    descriptionBuilderFrame:SetUserData("residenceText", residenceText);

    local residenceCheckBox = self._aceGUI:Create("CheckBox");
    residenceCheckBox:SetValue(false);
    residenceCheckBox:SetLabel("Residence");
    residenceCheckBox:SetRelativeWidth(0.5);
    residenceCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseResidence = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("residenceCheckBox", residenceCheckBox);
    basicDetailsGroup:AddChild(residenceCheckBox);

    local descriptiveDetailsGroup = self._aceGUI:Create("InlineGroup");
    descriptiveDetailsGroup:SetTitle("Descriptive details");
    descriptiveDetailsGroup:SetRelativeWidth(1);
    descriptiveDetailsGroup:SetLayout("Flow");
    descriptionBuilderFrame:AddChild(descriptiveDetailsGroup);

    local raceText = self._aceGUI:Create("EditBox");
    raceText:SetRelativeWidth(0.3);
    raceText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.Race = text;
    end);
    descriptiveDetailsGroup:AddChild(raceText);
    descriptionBuilderFrame:SetUserData("raceText", raceText);

    local raceCheckBox = self._aceGUI:Create("CheckBox");
    raceCheckBox:SetValue(false);
    raceCheckBox:SetLabel("Race");
    raceCheckBox:SetRelativeWidth(0.2);
    raceCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseRace = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("raceCheckBox", raceCheckBox);
    descriptiveDetailsGroup:AddChild(raceCheckBox);

    local ageText = self._aceGUI:Create("EditBox");
    ageText:SetRelativeWidth(0.3);
    ageText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.Age = text;
    end);
    descriptiveDetailsGroup:AddChild(ageText);
    descriptionBuilderFrame:SetUserData("ageText", ageText);

    local ageCheckBox = self._aceGUI:Create("CheckBox");
    ageCheckBox:SetValue(false);
    ageCheckBox:SetLabel("Age");
    ageCheckBox:SetRelativeWidth(0.2);
    ageCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseAge = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("ageCheckBox", ageCheckBox);
    descriptiveDetailsGroup:AddChild(ageCheckBox);

    local eyeColourText = self._aceGUI:Create("EditBox");
    eyeColourText:SetRelativeWidth(0.3);
    eyeColourText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.EyeColour = text;
    end);
    descriptiveDetailsGroup:AddChild(eyeColourText);
    descriptionBuilderFrame:SetUserData("eyeColourText", eyeColourText);

    local eyeColourCheckBox = self._aceGUI:Create("CheckBox");
    eyeColourCheckBox:SetValue(false);
    eyeColourCheckBox:SetLabel("Eye colour");
    eyeColourCheckBox:SetRelativeWidth(0.2);
    eyeColourCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseEyeColour = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("eyeColourCheckBox", eyeColourCheckBox);
    descriptiveDetailsGroup:AddChild(eyeColourCheckBox);

    local heightText = self._aceGUI:Create("EditBox");
    heightText:SetRelativeWidth(0.3);
    heightText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.Height = text;
    end);
    descriptiveDetailsGroup:AddChild(heightText);
    descriptionBuilderFrame:SetUserData("heightText", heightText);

    local heightCheckBox = self._aceGUI:Create("CheckBox");
    heightCheckBox:SetValue(false);
    heightCheckBox:SetLabel("Height");
    heightCheckBox:SetRelativeWidth(0.2);
    heightCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseHeight = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("heightCheckBox", heightCheckBox);
    descriptiveDetailsGroup:AddChild(heightCheckBox);

    local bodyShapeText = self._aceGUI:Create("EditBox");
    bodyShapeText:SetRelativeWidth(0.3);
    bodyShapeText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.BodyShape = text;
    end);
    descriptiveDetailsGroup:AddChild(bodyShapeText);
    descriptionBuilderFrame:SetUserData("bodyShapeText", bodyShapeText);

    local bodyShapeCheckBox = self._aceGUI:Create("CheckBox");
    bodyShapeCheckBox:SetValue(false);
    bodyShapeCheckBox:SetLabel("Body shape");
    bodyShapeCheckBox:SetRelativeWidth(0.2);
    bodyShapeCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseBodyShape = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("bodyShapeCheckBox", bodyShapeCheckBox);
    descriptiveDetailsGroup:AddChild(bodyShapeCheckBox);

    local hairText = self._aceGUI:Create("EditBox");
    hairText:SetRelativeWidth(0.3);
    descriptiveDetailsGroup:AddChild(hairText);
    hairText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.Hair = text;
    end);
    descriptionBuilderFrame:SetUserData("hairText", hairText);

    local hairCheckBox = self._aceGUI:Create("CheckBox");
    hairCheckBox:SetValue(false);
    hairCheckBox:SetLabel("Hair");
    hairCheckBox:SetRelativeWidth(0.2);
    hairCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseHair = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("hairCheckBox", hairCheckBox);
    descriptiveDetailsGroup:AddChild(hairCheckBox);

    local additionalDetailsGroup = self._aceGUI:Create("InlineGroup");
    additionalDetailsGroup:SetTitle("Additional details");
    additionalDetailsGroup:SetRelativeWidth(1);
    additionalDetailsGroup:SetLayout("Flow");
    descriptionBuilderFrame:AddChild(additionalDetailsGroup);

    local clothingWornText = self._aceGUI:Create("EditBox");
    clothingWornText:SetRelativeWidth(0.7);
    clothingWornText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.ClothingWorn = text;
    end);
    additionalDetailsGroup:AddChild(clothingWornText);
    descriptionBuilderFrame:SetUserData("clothingWornText", clothingWornText);

    local clothingWornCheckBox = self._aceGUI:Create("CheckBox");
    clothingWornCheckBox:SetValue(false);
    clothingWornCheckBox:SetLabel("Clothing worn");
    clothingWornCheckBox:SetRelativeWidth(0.3);
    clothingWornCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseClothingWorn = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("clothingWornCheckBox", clothingWornCheckBox);
    additionalDetailsGroup:AddChild(clothingWornCheckBox);

    local itemsCarriedText = self._aceGUI:Create("EditBox");
    itemsCarriedText:SetRelativeWidth(0.7);
    itemsCarriedText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.ItemsCarried = text;
    end);
    additionalDetailsGroup:AddChild(itemsCarriedText);
    descriptionBuilderFrame:SetUserData("itemsCarriedText", itemsCarriedText);

    local itemsCarriedCheckBox = self._aceGUI:Create("CheckBox");
    itemsCarriedCheckBox:SetValue(false);
    itemsCarriedCheckBox:SetLabel("Items carried");
    itemsCarriedCheckBox:SetRelativeWidth(0.3);
    itemsCarriedCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseItemsCarried = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("itemsCarriedCheckBox", itemsCarriedCheckBox);
    additionalDetailsGroup:AddChild(itemsCarriedCheckBox);

    local otherFeaturesText = self._aceGUI:Create("EditBox");
    otherFeaturesText:SetRelativeWidth(0.7);
    otherFeaturesText:SetCallback("OnEnterPressed", function(widget, event, text)
        self.CharacterData.OtherFeatures = text;
    end);
    additionalDetailsGroup:AddChild(otherFeaturesText);
    descriptionBuilderFrame:SetUserData("otherFeaturesText", otherFeaturesText);

    local otherFeaturesCheckBox = self._aceGUI:Create("CheckBox");
    otherFeaturesCheckBox:SetValue(false);
    otherFeaturesCheckBox:SetLabel("Other features");
    otherFeaturesCheckBox:SetRelativeWidth(0.3);
    otherFeaturesCheckBox:SetCallback("OnValueChanged", function(widget, event, isChecked)
        self.CharacterData.UseOtherFeatures = isChecked;
    end);
    descriptionBuilderFrame:SetUserData("otherFeaturesCheckBox", otherFeaturesCheckBox);
    additionalDetailsGroup:AddChild(otherFeaturesCheckBox);

    local descriptionBuilderCloseButton = self._aceGUI:Create("Button");
    descriptionBuilderCloseButton:SetText("Cancel");
    descriptionBuilderCloseButton:SetRelativeWidth(0.5);
    descriptionBuilderCloseButton:SetCallback("OnClick", function()
        local charDescSrv = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_CHARACTER_DESCRIPTION_SERVICE);

        charDescSrv.Widgets.DescriptionBuilderFrame:Hide();
    end);
    descriptionBuilderFrame:AddChild(descriptionBuilderCloseButton);

    local descriptionBuilderSubmitButton = self._aceGUI:Create("Button");
    descriptionBuilderSubmitButton:SetText("Submit");
    descriptionBuilderSubmitButton:SetRelativeWidth(0.5);
    descriptionBuilderSubmitButton:SetCallback("OnClick", function()
        local charDescSrv = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_CHARACTER_DESCRIPTION_SERVICE);

        callbackFunc(charDescSrv.CharacterData);
        charDescSrv.Widgets.DescriptionBuilderFrame:Hide();
    end);
    descriptionBuilderFrame:AddChild(descriptionBuilderSubmitButton);

end