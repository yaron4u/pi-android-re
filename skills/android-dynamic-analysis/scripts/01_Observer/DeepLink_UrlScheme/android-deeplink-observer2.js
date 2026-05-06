/* 
    Description: Android DeepLink Observer
    Usage: frida -U -p pid -l android-deeplink-observer2.js
    Credit: 8ksec
*/

var seenIntents = {};

Java.perform(function() {
    var Intent = Java.use("android.content.Intent");
    Intent.getData.implementation = function() {
        var action = this.getAction() !== null ? this.getAction().toString() : false;
        
        if (action) 
        {
            // Create a unique key for the current intent by concatenating its action and data URI
            var key = action + '|' + (this.getData() !== null ? this.getData().toString() : '');
            
            // Check if this intent has been seen before
            if (seenIntents.hasOwnProperty(key)) 
            {
                return this.getData();
            } 
            else 
            {
                // Mark this intent as seen by adding it to the global object
                seenIntents[key] = true;
                console.log("[*] Intent.getData() was called");
                console.log("[*] Activity: " + (this.getComponent() !== null ? this.getComponent().getClassName() : "unknown"));
                console.log("[*] Action: " + action);
                var uri = this.getData();

                if (uri !== null) 
                {
                    console.log("\\n[*] Data");
                    uri.getScheme() && console.log("- Scheme:\\t" + uri.getScheme() + "://");
                    uri.getHost() && console.log("- Host:\\t\\t/" + uri.getHost());
                    uri.getQuery() && console.log("- Params:\\t" + uri.getQuery());
                    uri.getFragment() && console.log("- Fragment:\\t" + uri.getFragment());
                    console.log("\\n\\n");
                } 
                else 
                {
                    console.log("[-] No data supplied.");
                }
            }
        }
        return this.getData();
    }
});