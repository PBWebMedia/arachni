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

module Reports

class HTML
module PluginFormatters

    #
    # @author Tasos "Zapotek" Laskos
    #                                      <tasos.laskos@gmail.com>
    #                                      <zapotek@segfault.gr>
    # @version: 0.1
    #
    class Resolver < Arachni::Plugin::Formatter

        def run
            return ERB.new( tpl ).result( binding )
        end

        def tpl
            %q{
                <h3>Results</h3>
                <table>
                    <tr>
                        <th>
                            Hostname
                        </th>
                        <th>
                            IP Address
                        </th>
                    </tr>
                <% @results.each do |hostname, ipaddress| %>
                    <tr>
                        <td>
                        <%= hostname %>
                        </td>
                        <td>
                        <%= ipaddress %>
                        </td>
                    </tr>
                <%end%>
                </table>
            }

        end

    end

end
end

end
end
