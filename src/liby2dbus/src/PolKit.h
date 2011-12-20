
/*
  PolicyKit access
*/

#ifndef PolKit_h
#define PolKit_h


#include <string>
#include <list>

#include <dbus/dbus.h>
#include <polkit/polkit.h>

class PolKit
{
    public:

	PolKit();
	~PolKit();

	bool isDBusUserAuthorized(const std::string &action_id, const std::string &dbus_caller,
	    DBusConnection *con, DBusError*err);



	static std::string createActionId(const std::string &prefix, const std::string &path,
	    const std::string &method, const std::string &arg = std::string(),
	    const std::string &opt = std::string());

	static std::string makeValidActionID(const std::string &s);

	static bool isValidActionID(const std::string &action);

    private:

	PolkitAuthority *pk_authority;
};

#endif

