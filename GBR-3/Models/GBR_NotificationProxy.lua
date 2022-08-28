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

    self.Notification.Title.Text:SetText(title);

end

function GBR_NotificationProxy:SetIncidentGrade(grade)

    local incidentGrade = string.format("GRADE %d", grade);
    self.Notification.IncidentGrade.Text:SetText(incidentGrade);
    self.Notification.GBRMetaGrade = grade;

end

function GBR_NotificationProxy:SetIncidentLocation(location, coordinateX, coordinateY)

    local locationText = location ~= nil and coordinateX ~= nil and coordinateY ~= nil
        and string.format("%s\n(%.2f, %.2f)", location, coordinateX, coordinateY)
        or location .. "\n-";

    self.Notification.IncidentLocation.Text:SetText(locationText);

end

function GBR_NotificationProxy:SetIncidentReporter(name)

    self.Notification.IncidentReporter.Text:SetText(name);

end

function GBR_NotificationProxy:SetIncidentFrequency(frequency)
    
    self.Notification.IncidentFrequency.Text:SetText(frequency);

end

function GBR_NotificationProxy:SetIncidentDescription(description)
    local incidentDescriptionText = "INCIDENT DETAILS\n" .. (description ~= nil 
        and description 
        or "Incident details not provided.");

    self.Notification.IncidentDescription.Text:SetText(incidentDescriptionText);

end

function GBR_NotificationProxy:SetUnitsRequired(unitsRequired)
    local unitsRequiredText = "UNITS REQUIRED\n" .. (unitsRequired ~= nil 
        and unitsRequired 
        or "Required unit details not provided.");
    self.Notification.UnitsRequired.Text:SetText(unitsRequiredText);

end