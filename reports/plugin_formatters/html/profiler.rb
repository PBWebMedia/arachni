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

require 'json'

module Arachni

module Reports

class HTML
module PluginFormatters

    #
    # HTML formatter for the results of the Profiler plugin
    #
    # @author Tasos "Zapotek" Laskos
    #                                      <tasos.laskos@gmail.com>
    #                                      <zapotek@segfault.gr>
    # @version: 0.2.1
    #
    class Profiler < Arachni::Plugin::Formatter
        include Arachni::Reports::HTML::Utils

        def run
            return ERB.new( IO.read( File.dirname( __FILE__ ) + '/profiler/template.erb' ) ).result( binding )
        end

    end

end
end

end
end
