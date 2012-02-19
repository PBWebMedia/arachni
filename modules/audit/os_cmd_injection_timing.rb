=begin
    Copyright 2010-2012 Tasos Laskos <tasos.laskos@gmail.com>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
=end

module Arachni

module Modules

#
# OS command injection module using timing attacks.
#
# @author Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: 0.2.2
#
# @see http://cwe.mitre.org/data/definitions/78.html
# @see http://www.owasp.org/index.php/OS_Command_Injection
#
class OSCmdInjectionTiming < Arachni::Module::Base

    include Arachni::Module::Utilities

    def prepare

        @@__injection_str ||= []

        if @@__injection_str.empty?
            read_file( 'payloads.txt' ) {
                |str|

                [ '', '&&', '|', ';' ].each {
                    |sep|
                    @@__injection_str << sep + " " + str
                }

                @@__injection_str << "`" + str + "`"
            }
        end

        @__opts = {
            :format  => [ Format::STRAIGHT ],
            :timeout => 10000,
            :timeout_divider => 1000
        }

    end

    def run
        audit_timeout( @@__injection_str, @__opts )
    end

    def redundant
        [ 'os_cmd_injection' ]
    end

    def self.info
        {
            :name           => 'OS command injection (timing)',
            :description    => %q{Tries to find operating system command injections using timing attacks.},
            :elements       => [
                Issue::Element::FORM,
                Issue::Element::LINK,
                Issue::Element::COOKIE,
                Issue::Element::HEADER
            ],
            :author         => 'Tasos "Zapotek" Laskos <tasos.laskos@gmail.com> ',
            :version        => '0.2.2',
            :references     => {
                 'OWASP'         => 'http://www.owasp.org/index.php/OS_Command_Injection'
            },
            :targets        => { 'Generic' => 'all' },
            :issue   => {
                :name        => %q{Operating system command injection (timing attack)},
                :description => %q{The web application allows an attacker to
                    execute arbitrary OS commands even though it does not return
                    the command output in the HTML body.
                    (This issue was discovered using a timing attack; timing attacks
                    can result in false positives in cases where the server takes
                    an abnormally long time to respond.
                    Either case, these issues will require further investigation
                    even if they are false positives.)},
                :tags        => [ 'os', 'command', 'code', 'injection', 'timing', 'blind' ],
                :cwe         => '78',
                :severity    => Issue::Severity::HIGH,
                :cvssv2       => '9.0',
                :remedy_guidance    => %q{User inputs must be validated and filtered
                    before being evaluated as OS level commands.},
                :remedy_code => '',
                :metasploitable => 'unix/webapp/arachni_exec'
            }

        }
    end

end
end
end
