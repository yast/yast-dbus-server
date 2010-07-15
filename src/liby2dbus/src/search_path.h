//
// Function for setting PATH environment variable if it's not defined
//

#include <cstdlib>
#include <ycp/y2log.h>

// check wheter PATH is defined, if not set it
bool set_path_env(const char *new_path)
{
    char *path = getenv("PATH");

    if (path == NULL)
    {
	// 1 = overwrite the existing
	return setenv("PATH", new_path, 1) == 0;
    }

    return false;
}

// set the default PATH value if not set
void set_default_path()
{
    const char *default_path = "/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin";

    if (set_path_env(default_path))
    {
        y2milestone("PATH environment set to: %s", default_path);
    }
}

