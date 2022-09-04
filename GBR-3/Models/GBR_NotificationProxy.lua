GBR_NotificationProxy = GBR_Object:New();

function GBR_NotificationProxy:New(obj)

    self.Notification = nil;

    return self:RegisterNew(obj);

end

function GBR_NotificationProxy:ApplyModel(notificationModel)

    self:SetTitle(notificationModel.Title);

    self:SetIncidentGrade(notificationModel.Grade);

    self:SetIncidentLocation(
        notificationModel.IncidentLocation, 
        notificationModel.LocationCoordinateX, 
        notificationModel.LocationCoordinateY);

    self:SetIncidentReporter(
        notificationModel.IncidentReporter, 
        notificationModel.IncidentReporterCallsign);

    self:SetIncidentFrequency(notificationModel.IncidentFrequency);

    self:SetIncidentDescription(notificationModel.IncidentDescription);

    self:SetUnitsRequired(notificationModel.UnitsRequired);

end

function GBR_NotificationProxy:SetTitle(title)

    local titleText = title and title:len() > 0 and title or "INCIDENT ALERT";
    self.Notification.Title.Text:SetText(titleText);

end

function GBR_NotificationProxy:SetIncidentGrade(grade)

    local incidentGrade = string.format("GRADE %d", grade);
    self.Notification.IncidentGrade.Text:SetText(incidentGrade);
    self.Notification.GBRMetaGrade = grade;

end

function GBR_NotificationProxy:SetIncidentLocation(location, coordinateX, coordinateY)

    local locationText;

    if location and location:len() > 0 then
        locationText = coordinateX and coordinateX:len() > 0 and coordinateY and coordinateY:len() > 0
            and string.format("%s\n(%s, %s)", location, coordinateX, coordinateY)
            or location .. "\n-";
    else
        locationText = "-";
    end

    self.Notification.IncidentLocation.Text:SetText(locationText);

end

function GBR_NotificationProxy:SetIncidentReporter(name)

    local incidentReporter = name and name:len() > 0 and name or "-";
    self.Notification.IncidentReporter.Text:SetText(incidentReporter);

end

function GBR_NotificationProxy:SetIncidentFrequency(frequency)
    
    self.Notification.IncidentFrequency.Text:SetText(frequency);

end

function GBR_NotificationProxy:SetIncidentDescription(description)
    local incidentDescriptionText = "INCIDENT DETAILS\n";
    
     if description and description:len() > 0 then
        incidentDescriptionText = incidentDescriptionText .. description;
     else
        incidentDescriptionText = incidentDescriptionText .. "Incident details not provided.";
     end

    self.Notification.IncidentDescription.Text:SetText(incidentDescriptionText);

end

function GBR_NotificationProxy:SetUnitsRequired(unitsRequired)
    local unitsRequiredText = "UNITS REQUIRED\n";

    if unitsRequired ~= nil and unitsRequired:len() > 0 then
        unitsRequiredText = unitsRequiredText .. unitsRequired;
    else
        unitsRequiredText = unitsRequiredText .. "Required unit details not provided.";
    end

    self.Notification.UnitsRequired.Text:SetText(unitsRequiredText);

end