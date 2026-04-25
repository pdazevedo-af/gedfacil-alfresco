/**
 * Gedfacil Dashboard Customization
 * Enforces a specific layout for non-admin users
 */

if (!user.isAdmin) {
    // Force a simple layout with only the "My Sites" dashlet
    model.columns = [
        {
            columnId: "column-1",
            dashlets: [
                {
                    url: "/components/dashlets/my-sites",
                    id: "dashlet-1-1"
                }
            ]
        }
    ];
    // Force a 1-column layout visually
    model.dashboardLayout = "dashboard-1-column";
}
