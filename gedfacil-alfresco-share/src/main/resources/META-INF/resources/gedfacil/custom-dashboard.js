// Script to hide Customize Dashboard for non-admins
if (typeof Alfresco !== "undefined" && Alfresco.constants && !Alfresco.constants.IS_ADMIN) {
    // Hide the 'Customize Dashboard' button in the dashboard page
    var hideCustomizeButton = function() {
        var button = document.querySelector('.customize-dashboard');
        if (button) {
            button.style.display = 'none';
        }
        // Also check for Aikau menu items
        var menuItems = document.querySelectorAll('.alfresco-menus-AlfUserMenuItem');
        menuItems.forEach(function(item) {
            if (item.textContent.toLowerCase().indexOf('dashboard') !== -1 && item.textContent.toLowerCase().indexOf('customize') !== -1) {
                item.style.display = 'none';
            }
        });
    };
    window.addEventListener('load', hideCustomizeButton);
    setInterval(hideCustomizeButton, 2000); // Check periodically for dynamic content
}
