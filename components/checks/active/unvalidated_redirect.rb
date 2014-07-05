=begin
    Copyright 2010-2014 Tasos Laskos <tasos.laskos@gmail.com>
    All rights reserved.
=end

# Unvalidated redirect check.
#
# It audits links, forms and cookies, injects URLs and checks the `Location`
# header field to determine whether the attack was successful.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>
# @version 0.2
# @see http://www.owasp.org/index.php/Top_10_2010-A10-Unvalidated_Redirects_and_Forwards
class Arachni::Checks::UnvalidatedRedirect < Arachni::Check::Base

    def self.payloads
        @payloads ||= [
            'www.arachni-boogie-woogie.com',
            'https://www.arachni-boogie-woogie.com',
            'http://www.arachni-boogie-woogie.com'
        ].map { |url| Arachni::URI( url ).to_s }
    end

    def self.payload?( url )
        (@set_payloads ||= Set.new( payloads )).include? Arachni::URI( url ).to_s
    end
    def payload?( url )
        self.class.payload? url
    end

    def run
        audit( self.class.payloads ) do |response, element|
            # If this was a sample/default value submission ignore it, we only
            # care about our payloads.
            next if !payload? element.seed

            # Simple check for straight HTTP redirection first.
            if payload? response.headers.location
                log vector: element, response: response
                next
            end

            # HTTP redirection check failed but if our payload ended up in the
            # response body it's worth loading it with a browser in case there's
            # a JS redirect.
            next if !response.body.include?( element.seed )

            with_browser do |browser|
                browser.load( response )

                if payload? browser.url
                    log vector: element, response: response
                end
            end
        end
    end

    def self.info
        {
            name:        'Unvalidated redirect',
            description: %q{Injects URLs and checks the Location HTTP response header field
                and/or browser URL to determine whether the attack was successful.},
            elements:    [Element::Form, Element::Link, Element::Cookie, Element::Header],
            author:      'Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>',
            version:     '0.2',

            issue:       {
                name:            %q{Unvalidated redirect},
                description:     %q{The web application redirects users to unvalidated URLs.},
                references:  {
                    'OWASP Top 10 2010' => 'http://www.owasp.org/index.php/Top_10_2010-A10-Unvalidated_Redirects_and_Forwards'
                },
                tags:            %w(unvalidated redirect injection header location),
                cwe:             819,
                severity:        Severity::MEDIUM,
                remedy_guidance: %q{Server side verification should be employed
                    to ensure that the redirect destination is the one intended.}
            }
        }
    end

end
