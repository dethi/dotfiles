import os


flags = [
    '-Wall',
    '-Wextra',
    '-Werror',
    '-isystem', '/usr/local/include',
    '-I.'
]


def make_path_absolute(flags, working_dir):
    if not working_dir:
        return list(flags)

    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_dir, flag)
        else:
            for path_flag in path_flags:
                if flag == path_flag:
                    make_next_absolute = True
                    break
                if flag.startswith(path_flag):
                    path = flag[len(path_flag):]
                    new_flag = path_flag + os.path.join(working_dir, path)
                    break

        if new_flag:
            new_flags.append(new_flag)

    return new_flags


def FlagsForFile(filename):
    '''Mandatory function used by YCM.'''
    final_flags = []
    if filename.endswith('.c'):
        final_flags.extend(['-std=c99', '-x', 'c'])
    else:
        final_flags.extend(['-std=c++14', '-x', 'c++'])

    relative_to = os.path.dirname(os.path.abspath(filename))
    final_flags.extend(make_path_absolute(flags, relative_to))
    return {'flags': final_flags, 'do_cache': True}
