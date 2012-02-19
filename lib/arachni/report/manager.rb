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

#
# The namespace under which all modules exist
#
module Reports
end

module Report

#
# Arachni::Report::Manager class
#
# Holds and manages the registry of the reports.
#
# @author Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr> <br/>
# @version: 0.1.1
#
class Manager < Arachni::ComponentManager

    include Arachni::Module::Utilities

    # the extension of the Arachni Framework Report files
    EXTENSION   = '.afr'

    def initialize( opts )
        super( opts.dir['reports'], Arachni::Reports )
        @opts = opts
    end

    #
    # Takes care of report execution
    #
    # @see AuditStore
    #
    # @param  [AuditStore]  audit_store
    #
    def run( audit_store, run_afr = true )
        if run_afr
            # run the default report first
            run_one( 'afr', audit_store.deep_clone )
            delete( 'afr' )
        end

        self.each {
            |name, report|
            exception_jail( false ){
                run_one( name, audit_store.deep_clone )
            }
        }
    end

    def run_one( name, audit_store )
        report = self.[](name).new( audit_store.deep_clone,
            prep_opts( name, self.[](name), @opts.reports[name] ) )

        report.run( )
    end

    def paths
        cpaths = paths = Dir.glob( File.join( "#{@lib}", "*.rb" ) )
        return paths.reject { |path| helper?( path ) }
    end


    def extension
        return EXTENSION
    end

end

end
end
