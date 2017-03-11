CMake
-----

Formatting
==========

No space between command and ``(``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: cmake

    # 'if' is not a keyword, it's a command, like 'execute_process'
    if(var1 EQUAL var2)
      command(...)
      command(...)
    endif()

Enclose path with double quotes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: cmake

  sugar_foo(sources "./sources")
      # sources - local variable
      # "./sources" - some directory

Next code produce error ``set_target_properties called with incorrect number of arguments``:

.. code-block:: cmake

    set(x "")
    set_target_properties(foo PROPERTIES INCLUDE_DIRECTORIES ${x})

Works fine:

.. code-block:: cmake

    set(x "")
    set_target_properties(foo PROPERTIES INCLUDE_DIRECTORIES "${x}")

Example with `file(WRITE ...) <https://cmake.org/cmake/help/v3.3/command/file.html>`_:

.. code-block:: cmake

    file(WRITE "${A}/path/to/file/with spaces/in" "message") # quotes required
    file(WRITE "${A}/path/to/file/without-spaces/in" "message") # quotes not necessary but keep style the same

Note that quotes required for anything related to `configure_file <https://cmake.org/cmake/help/v3.3/command/configure_file.html>`_:

.. code-block:: cmake

    # script.cmake.in
    file(WRITE ${filename} ${content})

.. code-block:: cmake

    set(filename "/path/with/spaces/A B C")
    set(content "a b c")
    configure_file(.../script.cmake.in .../script.cmake)
    execute_process(COMMAND ${CMAKE_COMMAND} -P .../script.cmake ...)

Result will be creation of file ``/path/with/spaces/A`` with content ``BCabc``.
Fix:

.. code-block:: cmake

    # script.cmake.in
    file(WRITE "${filename}" "${content}")

or

.. code-block:: cmake

    # script.cmake.in
    file(WRITE "@filename@" "@content@")

Quite the same happens in ``install(CODE`` command:

.. code-block:: cmake

  install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E echo hello ...)")

content of ``cmake_install.cmake`` will be:

.. code-block:: cmake

  execute_process(COMMAND /.../bin/cmake.exe -E echo hello ...) # no quotes!

it means that if CMake is installed to path with spaces this command will not
be executed.

Indentation
===========

2 spaces is default indentation:

.. code-block:: cmake

  command(...)
  command(...)
  if(...)
    # +2 spaces
    command(...)
    if(...)
      # +2 spaces
    endif()
  endif()

  function(...)
    # +2 spaces
    command(...)
  endfunction()

Use 4 spaces for breaking long line:

.. code-block:: cmake

  command(short line)

.. code-block:: cmake

  command(
      # +4 spaces
      long line arg1 arg2
  )

.. code-block:: cmake

  command(
      # +4 spaces
      very
      long
      line
      arg1
      arg2
      arg3
  )

alternatively same line can be kept for name-value:

.. code-block:: cmake

  command(
      # +4 spaces
      VALUE1 value1
      VALUE2 value2
      VALUE3 value3
      # break long line with additional indentation
      VALUE4
          # +4 spaces
          value4a
          value4b
          value4c
  )

Naming
======

Lower case for `commands <http://www.cmake.org/cmake/help/v2.8.11/cmake.html#section_Commands>`_:

.. code-block:: cmake

  if(A)
    command(...)
  endif()

Upper case for command specifiers:

.. code-block:: cmake

  list(APPEND list_var append_var)

Lower case for local variables (temps, parameters, ...):

.. code-block:: cmake

  foreach(x ${ARGV})
    message(${x})
  endforeach()

Upper case for global variables (like variables which Find-modules use/setup):

.. code-block:: cmake

  include(ModuleA) # define MODULE_A_MODE
  if(MODULE_A_MODE)
    command(...)
  endif()

Lower case for function/macro names:

.. code-block:: cmake

  macro(do_foo)
    command(...)
  endmacro()

  do_foo(...)

Start internal variable's name with the ``_`` in macro and headers:

.. code-block:: cmake

  macro(do_foo)
    # command `macro` doesn't introducing new scope
    # hence this `set` commands will pollute user's space
    set(_value1 "...")
    set(_value2 "...")
    # ...
  endmacro()

.. code-block:: cmake

  # MyModule.cmake
  # same for the header
  string(COMPARE EQUAL "${A}" "${B}" _is_equal)
  if(_is_equal)
    # ...
  endif()

.. code-block:: cmake

  # variable _is_equal not defined
  include(MyModule)
  # variable _is_equal defined

Examples:

* `Qt4Macro.cmake <https://github.com/Kitware/CMake/blob/b583800203aea14aa03629bd27ad07d3f9440b17/Modules/Qt4Macros.cmake#L253>`_
* `OpenCVUtils.cmake <https://github.com/Itseez/opencv/blob/09b9b0fb9e9c9dd8c9e0d65705f8f19aa4c27f8a/cmake/OpenCVUtils.cmake#L205>`_

.. note:: Use `functions <https://cmake.org/cmake/help/v3.3/command/function.html>`_ when it's possible!

To prevent collisions guard variable name should match path to the module:

.. code-block:: cmake

  # module flags/gcc.cmake from project Polly
  if(DEFINED POLLY_FLAGS_GCC_CMAKE_)
    return()
  else()
    set(POLLY_FLAGS_GCC_CMAKE_ 1)
  endif()

.. code-block:: cmake

  # module cmake/Hunter from project Hunter
  if(DEFINED HUNTER_CMAKE_HUNTER_)
    return()
  else()
    set(HUNTER_CMAKE_HUNTER_ 1)
  endif()

.. note:: Inspired by `Google C++ Style Guide - The #define Guard <https://google.github.io/styleguide/cppguide.html#The__define_Guard>`_

Pitfalls
========

STREQUAL
~~~~~~~~

Usage of ``if(${A} STREQUAL ${B})`` is **not** recommended, see
`this SO question <http://stackoverflow.com/questions/19982340/cmake-compare-to-empty-string-with-strequal-failed>`_.
Preferable function is `string <https://cmake.org/cmake/help/v3.3/command/string.html>`_:

.. code-block:: cmake

  string(COMPARE EQUAL "${A}" "${B}" result)
  if(result)
    message("...")
  endif()

.. note::
  Fixed in CMake 3.1 by `CMP0054 policy <https://cmake.org/cmake/help/v3.1/policy/CMP0054.html>`_

export(PACKAGE ...)
~~~~~~~~~~~~~~~~~~~

* Avoid modification of "global" space. See `Bug 14849 <http://www.cmake.org/Bug/view.php?id=14849>`_
* `Disabling package registry <http://www.cmake.org/cmake/help/v3.1/manual/cmake-packages.7.html#disabling-the-package-registry>`_

Library of CMake extra modules
==============================

* All defined functions/macros start with ``<libname>_`` (`example <https://github.com/ruslo/sugar/tree/master/cmake/utility>`_)
* no ``message`` command inside, only `wrappers <https://github.com/ruslo/sugar/tree/master/cmake/print>`_

 * ``<libname>_STATUS_PRINT`` option control ``message`` output (default value is ``ON``)
 * ``<libname>_STATUS_DEBUG`` option used for more verbose output and additional debug checks (default value is ``OFF``)

* one function/macro - one file
* ``<include-name>`` equal ``<function-name>``

As the result: include only what you need, check that included function
is used by simple in-file search (and, of course, delete it if it's not). If
you need to use ``sugar_foo_boo`` function, just include ``sugar_foo_boo.cmake``:

.. code-block:: cmake

  include(sugar_foo_boo) # load sugar_foo_boo.cmake file with sugar_foo_boo function
  sugar_foo_boo(some args) # use it

Note about wrappers
===================

Probably some wrappers (like `sugar_fatal_error <https://github.com/ruslo/sugar/blob/master/cmake/print/sugar_fatal_error.cmake>`_)
occupy more space than functionality it is wrapping (: The purpose of this
functions is to make additional check. See the difference between this two
misprints:

.. code-block:: cmake

  message(FATA_ERROR "SOS!") # Output will be: "FATA_ERRORSOS!", no error report...

.. code-block:: cmake

  include(sugar_fata_error) # include error will be reported

.. code-block:: cmake

  sugar_fata_error(...) # function not found error will be reported

iOS detection
=============

Polly toolchain set `IOS variable <https://github.com/ruslo/polly/blob/b763045f6e24475e9e33c5df7b58ba32c428f86c/os/iphone.cmake#L122>`_:

.. code-block:: cmake

  if(IOS)
    # iOS code
  endif()

also `CMAKE_OSX_SYSROOT <https://github.com/ruslo/polly/blob/b763045f6e24475e9e33c5df7b58ba32c428f86c/os/iphone.cmake#L10>`_
can be checked:

.. code-block:: cmake

  string(COMPARE EQUAL "${CMAKE_OSX_SYSROOT}" "iphoneos" is_ios)

Temporary directories
=====================

* ``${PROJECT_BINARY_DIR}/_3rdParty/<libname>``
