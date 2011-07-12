var debug = {
    /* Borrowed from <http://www.syger.it/Tutorials/JavaScriptIntrospector.html> */
    typeOf : function (obj) {
        type = typeof obj;
        return type === "object" && !obj ? "null" : type;
    },
    
    /* Borrowed from <http://www.syger.it/Tutorials/JavaScriptIntrospector.html> */
    introspect : function (obj, levels, name, indent) {
        if (this.typeOf(levels) !== "number") levels=1;
        name = name || "";
        indent = indent || "  ";

        var objType = this.typeOf(obj);
        var result = [indent, name, " ", objType, " :"].join('');
        if (objType === "object") {
            if (levels > 0) {
                indent = [indent, "  "].join('');
                for (prop in obj) {
                    var prop = this.introspect(
                        obj[prop], levels-1, prop, indent);
                    result = [result, "\n", prop].join('');
                }
                return result;
            }
            else {
                return [result, " ..."].join('');
            }
        }
        else if (objType === "null") {
            return [result, " null"].join('');
        }
        return [result, " ", obj].join('');
    }
};