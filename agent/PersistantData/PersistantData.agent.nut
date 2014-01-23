/***************************************************************************
 * PersistantData is a static class that wraps up the 
 * server.save() and server.load() functionality into 
 * a tidy package.
 *
 * Usage:
 * ======
 * - You do not need to initialize PersistantData
 * - To check whether the datastore has a particular key, call 
 *   PersistantData.hasKey("someKey")
 * - To get the value of data stored with a particular key, call
 *   PersistantData.get("someKey")
 *   - If the key does not exist in the datastore, it will return null
 * - To save data with a key, call PersistantData.set("someKey", value)  
 * - To remove a key from the datastore, call PersistantData.remove("someKey")
 * - At anytime, you can call PersistantData.refresh() to pull down the latest
 *   version of agent's datastore.
 * - To clear out the datastore, use PersistantData.clear()
 *   - This is the equivalent of server.save({});
 * 
 * NOTE: If you use the PersistantData static class, you should *NEVER* call
 * server.save() or server.load(). Additionally, you should *NEVER* directly
 * access PersistantData._data - instead, use the provided functions.
 ***************************************************************************/
 
PersistantData <- {
  function hasKey(key) {
    _checkData();
    return (key in _data);
  }
  
  function get(key) {
    _checkData();
    if(!hasKey(key)) return null;
    return _data[key];
  }
  
  function set(key, value) {
    _checkData();
    _data[key] <- value;
    server.save(_data);
  }
  
  function remove(key) {
    _checkData();
    if (hasKey(key)) {
      delete _data[key];
      server.save(_data);
    }
  }
  
  function refresh() {
    _data <- server.load();
  }
  
  function clear() {
    server.save({});
    refresh();
  }


  /***** Private - do not call below *****/
  _data = null

  function _checkData() {
    if(!_data) refresh();
  }
}

/********** Examples / Tests **********/

// Clear out data so we know the state of our datastore
PersistantData.clear();

// test should be null since the table is empty
server.log("hasKey('test'): " + PersistantData.hasKey("test"));

// save some data
PersistantData.set("test", 123);
server.log("save('test', 123)");
// hasKey("test") should return true
server.log("hasKey('test'): " + PersistantData.hasKey("test"));
// get("test") should return 123
server.log("get('test'): " + PersistantData.get("test"));

// remove test
PersistantData.remove("test");
server.log("remove('test')");
// hasKey("test") should return false
server.log("hasKey('test'): " + PersistantData.hasKey("test"));
// get("test") should return null
server.log("get('test'): " + PersistantData.get("test"));

// remove("notAKey") should not throw an error
PersistantData.remove("notAKey");
server.log("remove('notAKey')");

