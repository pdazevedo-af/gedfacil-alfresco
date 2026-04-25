/**
 * Gedfacil Header Customization
 * Hides customization options for users in the GROUP_PESQUISADOR
 */

var isPesquisador = false;

// Call repository to check group membership
// The API /api/people/{username}?groups=true returns the groups of the user
var result = remote.call("/api/people/" + encodeURIComponent(user.id) + "?groups=true");

if (result.status == 200 && result.text) {
    try {
        var person = JSON.parse(result.text);
        var groups = person.groups;
        if (groups) {
            for (var i = 0; i < groups.length; i++) {
                if (groups[i].itemName == "GROUP_PESQUISADOR") {
                    isPesquisador = true;
                    break;
                }
            }
        }
    } catch (e) {
        // Log error or ignore to prevent 500 error
    }
}

// Note: Aikau customizations (HEADER_CUSTOMIZE_DASHBOARD) should be handled in share-header.get.js
// header.get.js is for the legacy YUI header.
