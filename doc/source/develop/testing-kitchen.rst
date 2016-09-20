
Openstack-Satl Formula Testing
==============================

In order to provide pull requests without syntax or functional bugs developer are suggested to write test-cases for implemented
features and run rehearsal test prior sending a pull request.

To simulate supported platforms, environments and versions the openstack-salt formulas uses a Test Kitchen framework to
simplify this procedure on a developer side.

Introduction
------------------------------

In this section is described common development and test workflow with `Test Kitchen <http://kitchen.ci>`_ and
`kitchen-salt <https://github.com/simonmcc/kitchen-salt>`_ provisioner plugin.

Test Kitchen is a test harness tool to execute your configured code on one or more platforms in isolation.
There is a ``.kitchen.yml`` in main directory that defines *platforms* to be tested and *suites* to execute on them.

Kitchen CI can spin instances locally or remote, based on used *driver*.
For local development ``.kitchen.yml`` defines a `vagrant <https://github.com/test-kitchen/kitchen-vagrant>`_ or
`docker  <https://github.com/test-kitchen/kitchen-docker>`_ driver.

A listing of scenarios to be executed:

.. code-block:: shell

  $ kitchen list

  Instance                    Driver   Provisioner  Verifier  Transport  Last Action

  cluster-ubuntu-1404        Vagrant  SaltSolo     Inspec    Ssh        <Not Created>
  cluster-ubuntu-1604        Vagrant  SaltSolo     Inspec    Ssh        <Not Created>
  cluster-centos-71          Vagrant  SaltSolo     Inspec    Ssh        <Not Created>
  single-fernet-ubuntu-1404  Vagrant  SaltSolo     Inspec    Ssh        <Not Created>
  single-fernet-ubuntu-1604  Vagrant  SaltSolo     Inspec    Ssh        <Not Created>
  single-fernet-centos-71    Vagrant  SaltSolo     Inspec    Ssh        <Not Created>
  single-ubuntu-1404         Vagrant  SaltSolo     Inspec    Ssh        <Not Created>
  single-ubuntu-1604         Vagrant  SaltSolo     Inspec    Ssh        <Not Created>
  single-centos-71           Vagrant  SaltSolo     Inspec    Ssh        <Not Created>

The `Busser <https://github.com/test-kitchen/busser>`_ *Verifier* is used to setup and run tests
implementated in `<repo>/test/integration`. It installs the particular driver to tested instance
(`Serverspec <https://github.com/neillturner/kitchen-verifier-serverspec>`_,
`InSpec <https://github.com/chef/kitchen-inspec>`_, Shell, Bats, ...) prior the verification is
executed.


Usage:

.. code-block:: shell

  # list instances and status
  kitchen list

  # manually execute integration tests
  kitchen [test || [create|converge|verify|exec|login|destroy|...]] [instance] -t tests/integration

  # use with provided Makefile (ie: within CI pipeline)
  make kitchen


Continuous Integration:

For CI purposes there is a `make kitchen` target defined in `Makefile` in each formula to perform following (Kitchen Test) actions:

1. *create*, provision an test instance (VM, container)
2. *converge*, run a provisioner (shell script, kitchen-salt)
3. *verify*, run a verification (inspec, other may be added)
4. *destroy*


Test Kitchen
----------------------------------------

Install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To install Test Kitchen is as simple as:

.. code-block:: shell

  # install kitchen
  gem install test-kitchen

  # install required plugins
  gem install kitchen-vagrant kitchen-docker kitchen-salt

  # install additional plugins & tools
  gem install kitchen-openstack kitchen-inspec busser-serverspec

  kitchen list
  kitchen test

of course you have to have installed Ruby and it's package manager `gem <https://rubygems.org/>`_ first.

One may be satisfied installing it system-wide right from OS package manager which is preferred installation method.
For advanced users or the sake of complex environments you may use `rbenv <https://github.com/rbenv/rbenv>`_ for user side ruby installation.

 * https://github.com/rbenv/rbenv
 * http://kitchen.ci/docs/getting-started/installing

An example steps then might be:

.. code-block:: shell

  # get rbenv
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv

  # configure
  cd ~/.rbenv && src/configure && make -C src     # don't worry if it fails
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"'>> ~/.bash_profile
  # Ubuntu Desktop note: Modify your ~/.bashrc instead of ~/.bash_profile.
  cd ~/.rbenv; git fetch

  # install ruby-build, which provides the rbenv install command
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

  # list all available versions:
  rbenv install -l

  # install a Ruby version
  # maybe you will need additional packages: libssl-dev, libreadline-dev, zlib1g-dev
  rbenv install 2.0.0-p648

  # activate
  rbenv local 2.0.0-p648

  # install test kitchen
  gem install test-kitchen


An optional ``Gemfile`` in the main directory may contain Ruby dependencies to be required for Test Kitchen workflow.
To install them you have to install first ``gem install bundler`` and then run ``bundler install``.


Test Kitchen Backends
-----------------------------------

If you would like to use other than standard backend or if you would like to customize configuration for your local
environment then you may use ``.kitchen.<backend>.yml`` configuration yaml in the main directory to override ``.kitchen.yml`` at some points.

Usage: ``KITCHEN_LOCAL_YAML=.kitchen.<driver>.yml kitchen verify server-ubuntu-1404 -t tests/integration``.
Example: ``KITCHEN_LOCAL_YAML=.kitchen.docker.yml kitchen verify server-ubuntu-1404 -t tests/integration``.

Be aware of fundamental differences of backends. The formula verification scripts are primarily tested with
Vagrant driver.


Test cases, verifiers
----------------------------------

The `Busser <https://github.com/test-kitchen/busser>`_ *Verifier* goes with test-kitchen by default.
It is used to setup and run tests implemented in `<repo>/test/integration`. It guess and installs the particular driver to tested instance.
By default `InSpec <https://github.com/chef/kitchen-inspec>`_ is expected.

You may avoid to install busser framework if you configure specific verifier in `.kitchen.yml` and install it kitchen plugin locally:

	verifier:
		name: serverspec

If you would to write another verification scripts than InSpec store them in ``<repo>/tests/integration/<suite>/<busser>/*`` with ``_spec.rb`` filename suffix.

``Busser <https://github.com/test-kitchen/busser>`` is a test setup and execution framework under test kitchen.


InSpec
~~~~~~~~~~~~~~~~~

InSpec is an open-source testing framework for infrastructure with a human- and machine-readable language for specifying compliance, security and policy requirements.

Inspired by ServerSpec => more features available:

* Built-in Compliance: Compliance no longer occurs at the end of the release cycle
* Targeted Tests: InSpec writes tests that specifically target compliance issues
* Metadata: Includes the metadata required by security and compliance pros
* Easy Testing: Includes a command-line interface to run tests quickly

There are two usage scenarios for inspec.
  * as a compliance/audit profile tool
  * as a infrastructure verification tool after the configuration management configured the node

The purpose of InSpec tests under formulas is not /just/ perform TTD part of the game, in other words verify Salt/Chef/Ansible did a job right,  but to verify final infrastructure state. For example, Salt may configure service to run and start it. But it might also fail soon later. Infrastructure tests are here to repeatedly query infrastructures and provide audit reports. You may than set up triggers to take action if for example an "security" audit rule fail on the node.

Examples:
.. code-block:: ruby

	describe package('telnetd') do
	  it { should_not be_installed }
	end

	describe inetd_conf do
	  its("telnet") { should eq nil }
	end

Advanced:
.. code-block:: ruby

	only_if do
	  command('sshd').exist?
	end

	control "sshd-11" do
	  impact 1.0
	  title "Server: Set protocol version to SSHv2"
	  desc "Set the SSH protocol version to 2. Don't use legacy
	        insecure SSHv1 connections anymore."
	  tag security: "openssh-server"
	  ref "Document A-12"

	  describe sshd_config do
	    its('Protocol') { should eq('2') }
	  end
	end

CLI:
.. code-block:: shell

	# run test on remote host on SSH
	inspec exec test.rb -t ssh://user@hostname

	# run test on remote windows host on WinRM
	inspec exec test.rb -t winrm://Administrator@windowshost --password 'your-password'


Reference:
* https://docs.chef.io/inspec_reference.html
* https://github.com/chef/inspec/tree/master/docs
* https://github.com/chef/inspec/blob/master/docs/resources.rst

Repos:
* https://github.com/chef/inspec
* https://github.com/chef/kitchen-inspec

Docs:
* https://github.com/chef/inspec#documentation

Security, hardening profiles:
* https://supermarket.chef.io/tools/os-hardening
* https://supermarket.chef.io/tools/ssh-hardening
* https://supermarket.chef.io/tools/cis-docker-benchmark

Tutorials on-line:
* http://www.anniehedgie.com/inspec-basics-1
* http://www.anniehedgie.com/inspec-basics-2
* http://www.anniehedgie.com/inspec-basics-3
* http://www.anniehedgie.com/inspec-basics-4

