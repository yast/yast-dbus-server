
/*
  PolKit implementation
*/

#include "PolKit.h"

#include <ycp/y2log.h>

#include <map>

PolKit::PolKit()
{
    pk_authority = polkit_authority_get();
}

PolKit::~PolKit()
{
    // release the PolkitAuthority object
    g_object_unref(pk_authority);
}


bool PolKit::isDBusUserAuthorized(const std::string &action_id, const std::string &dbus_caller, DBusConnection *con, DBusError *err)
{
    y2debug("Checking action %s from %s", action_id.c_str(), dbus_caller.c_str());

    PolkitSubject *pk_subject = polkit_system_bus_name_new(dbus_caller.c_str());

    if (pk_subject == NULL)
    {
	y2error("PolkitSubject is NULL!");
	return false;
    }

    GError *polkit_error = NULL;

    PolkitAuthorizationResult *pk_result = polkit_authority_check_authorization_sync(
	pk_authority, pk_subject, action_id.c_str(), NULL, POLKIT_CHECK_AUTHORIZATION_FLAGS_NONE, NULL, &polkit_error);

    g_object_unref(pk_subject); 

    if (polkit_error)
    {
	y2error("polkit error: %s", polkit_error->message);

	// set a DBus error here
	dbus_set_error(err, "%s:%s", action_id.c_str(), polkit_error->message);

        g_error_free(polkit_error);
    }

    // remember the result before freeing the object
    bool result = polkit_authorization_result_get_is_authorized(pk_result);

    // free the result object
    g_object_unref(pk_result);

    return result;
}

std::string PolKit::makeValidActionID(const std::string &s)
{
    if (s.empty())
	return s;

    std::string ret;
    // reserve enough space in advance, but not more than 255 characters
    ret.reserve(s.size() & 255);

    bool was_invalid_char = false;

    for (std::string::size_type i = 0; i < s.length(); ++i)
    {
	char ch = s[i];

	// skip valid charcters
	if (islower(ch) || isdigit(ch) || ch == '.' || ch == '-')
	{
	    ret.push_back(ch);
	    was_invalid_char = false;
	}
	// convert uppercase to lowercase
	else if (isupper(ch))
	{
	    ret.push_back(tolower(ch));
	    was_invalid_char = false;
	}
	else
	{
	    if (!was_invalid_char)
	    {
		// replace invalid characters
		ret.push_back('-');
		was_invalid_char = true;
	    }
	}

	if (ret.size() == 255)
	    break;
    }

    return ret;
}

std::string PolKit::createActionId(const std::string &prefix, const std::string &path, const std::string &method,
	    const std::string &arg, const std::string &opt)
{
    std::string action_id(prefix + "." + method + path);

    // use arg and opt for generic agents (like .target.bash) to allow only some arguments
    if(::strncmp(path.c_str(), ".target.", ::strlen(".target.")) == 0 ||
	::strncmp(path.c_str(), ".background.", ::strlen(".background.")) == 0 ||
	::strncmp(path.c_str(), ".process.", ::strlen(".process.")) == 0 ||
	method == "RegisterAgent")
    {
	action_id += arg + opt;
    }

    // actionID must contain only [a-z][0-9] and .- characters, max. length is 255 characters
    action_id = makeValidActionID(action_id);

    return action_id;
}

bool PolKit::isValidActionID(const std::string &action)
{
    int str_size = action.size();

    // action ID must not exceed 255 characters
    if (str_size > 255) return false;

    // only lower case ASCII characters, numbers, period (.) and hyphen (-)
    // are allowed in action ID (see man polkit)

    int idx = 0;
    while (idx < str_size)
    {
	char ch = action[idx];
	if (!(islower(ch) || isdigit(ch) || ch == '.' || ch == '-'))
	{
	    return false;
	}

	idx++;
    }

    return true;
}

