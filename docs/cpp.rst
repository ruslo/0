.. spelling::

  eader
  emplate
  lus
  mplementation
  orward

C++
---

``... WORK-IN-PROGRESS ...``

File extensions
===============

* ``.fpp`` - **F**\ orward declaration C **P**\ lus **P**\ lus
* ``.hpp`` - **H**\ eader C **P**\ lus **P**\ lus
* ``.ipp`` - Template **I**\ mplementation C **P**\ lus **P**\ lus
* ``.cpp`` - **C** **P**\ lus **P**\ lus source file
* ``.tpp`` - **T**\ emplate instantiation C **P**\ lus **P**\ lus

.. note:: Example of `vimrc <https://github.com/ruslo/configs/blob/562f0d054063382c28afaf86ed0a05465e4201e4/vim/vimrc#L121>`_

Compilers limitations
=====================

MSVC 2013
~~~~~~~~~

* Use ``BOOST_NOEXEPT`` instead of ``noexcept``
* `<http://wiki.apache.org/stdcxx/C++0xCompilerSupport>`_
* `<http://msdn.microsoft.com/en-us/library/hh567368.aspx>`_

Other
~~~~~

* Prefer ``#if defined(SOMETHING)``, but not ``#ifdef (SOMETHING)``
* Explicitly deleting move constructor/operator= at least redundant: http://stackoverflow.com/a/23771245/2288008
