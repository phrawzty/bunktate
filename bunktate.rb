require 'rubygems'
require 'tire'
require 'optparse'



# Perform the re-indexing procedure.
def rotate (es_url, hot, cold)
    Tire.configure {
        url es_url
    }

    # do the re-index
    begin
        result = Tire.index(hot).reindex cold
    rescue
        # some sort of fancy error handling here. :P
    end

    return result
end

# Determine the index names.
def index_names (date, hot, cold)
    raise 'invalid date object' unless date.is_a?(Time)

    indices = {}
    indices[:hot] = "#{hot}#{date.strftime('%Y.%m.%d')}"
    indices[:cold] = "#{cold}#{date.strftime('%Y.%m.%d')}"

    return indices
end

# If the user supplied a date at runtime.
def parse_date (date)
    raise 'invalid fate format' unless date.match(/^\d+\.\d+\.\d+$/)

    date = date.split('.')
    time = Time.local(date[0], date[1], date[2])

    return time
end

# Runtime args.
def parse_args (options)
    optparse = OptionParser.new do |opts|
        opts.banner = "Usage: #{$0} -e <es_url>"

        opts.on('-?', '--help', 'Help!') do
            puts opts
            exit 1
        end

        options[:es_url] = false
        opts.on('-e', '--es_url URL', 'Full URL to ES service.') do |x|
            options[:es_url] = x
        end

        options[:hot] = 'logstash-'
        opts.on('-h', '--hot PREFIX', 'Prefix of hot index name.') do |x|
            options[:hot] = x
        end

        options[:cold] = 'logstash-'
        opts.on('-c', '--cold PREFIX', 'Prefix of cold index name.') do |x|
            options[:cold] = x
        end

        options[:date] = Time.now - 86400
        opts.on('-d', '--date YYYY.mm.dd', 'Date to rotate for.') do |x|
            options[:date] = parse_date(x)
        end
    end

    optparse.parse!

    # Sanity checking; easy to add to for later expansion.
    errors = []
    errors << 'Must provide ES URL' unless options[:es_url]

    if errors.length > 0 then
        errors.each do |x|
            puts x
        end
        puts "PRO TIP: Try --help for more information."
        exit 1
    end

    return options
end



# RUN LOLA RUN!
options = parse_args(options = {})
names = index_names(options[:date], options[:hot], options[:cold])
rotate(options[:es_url], names[:hot], names[:cold])
