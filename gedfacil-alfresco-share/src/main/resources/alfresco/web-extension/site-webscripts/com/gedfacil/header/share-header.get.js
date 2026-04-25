/**
 * Gedfacil Header Customization
 * Hides customization options for users who are NOT in the ALFRESCO_ADMINISTRATORS group
 */

var isAdmin = user.isAdmin;

// Requirement: Any user NOT in ALFRESCO_ADMINISTRATORS
if (!isAdmin && model.jsonModel != null) {
    // Hide the "Customize Dashboard" button on the dashboard page
    widgetUtils.deleteObjectFromArray(model.jsonModel, "id", "HEADER_CUSTOMIZE_DASHBOARD");
    
    // Hide the "Customize Dashboard" option in the User Menu
    widgetUtils.deleteObjectFromArray(model.jsonModel, "id", "HEADER_CUSTOMIZE_USER_DASHBOARD");
}
