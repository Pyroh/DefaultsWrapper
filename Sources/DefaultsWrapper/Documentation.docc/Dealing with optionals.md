# Dealing with optionals 

Every type usable with `@Defaults`, `@Preference` and `@SavedState` can also be used while being optional. 

## Overview

The wrapper behavior is slightly different when bound to an optional type : 

#### If a default value is provided 
- the property **will never return `nil`**
- it will return the actual value or the default value
- setting the property to `nil` will remove the value from the user's defaults database

#### If no default value is provided or the default value is `nil` 
- the property **can return `nil`** 
- it will return the actual value or `nil` if there's no registered value for this key 
- setting the property to `nil` will remove the value from the user's defaults detabase

