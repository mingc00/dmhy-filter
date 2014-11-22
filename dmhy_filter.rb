#! /usr/bin/env ruby
require 'rss/2.0'
require 'rss/maker'
require 'open-uri'
require 'date'
require 'yaml'

class RssProcessor

  def initialize(config_file)
    @config_file = config_file
    baseDir = File.dirname(__FILE__)
    puts baseDir
    default_options = {
      'source'=> 'http://share.dmhy.org/topics/rss/sort_id/2/rss.xml',
      'filter'=> File.join(baseDir, 'filter.txt'),
      'output'=> File.join(baseDir, 'feed.xml'),
      'expired_day'=> 3,
      'last_updated'=> Time.now - 600
    }
    if File.exist? config_file
      config_options = YAML.load_file(config_file)
    else
      config_options = {}
    end
    @options = default_options.merge(config_options)

    make_sure_existed @options['filter']

    @filter = []
    File.open @options['filter'] do |f|
      @filter = f.readlines.map { |l| Regexp.new(l.split.join('.*?')) }
    end
  end

  def process
    if not File.exist? @options['output']
      create_empty_rss
    end

    output_rss = nil
    File.open @options['output'] do |f|
      output_rss = RSS::Parser.parse(f)
    end
    if output_rss == nil
      $stderr.puts "[Error] Fail to parse #{@options['output']}"
      exit
    end

    # remove items which are expired
    output_rss.items.reject! { |e| Time.now - e.pubDate > @options['expired_day'] * 86400 }

    online_rss = fetch_online_rss
    is_updated = false

    # filter for online rss
    online_rss.items.each do |item|
      break if item.pubDate <= @options['last_updated']
      @filter.each do |re|
        if item.title =~ re then
          is_updated = true
          output_rss.items << item
          break
        end
      end
    end
    @options['last_updated'] = output_rss.channel.pubDate = online_rss.items.first.pubDate

    # save config
    File.open(@config_file, 'w') { |f| f.write(YAML.dump(@options)) }

    # save output
    if is_updated then
      File.open(@options['output'], 'w') { |f| f.write(output_rss) }
    end
  end

  private
  def make_sure_existed(filename)
    if not File.exist? filename
      $stderr.puts "[Error] File #{filename} not found!"
      exit
    end
  end

  def create_empty_rss
    empty_rss = RSS::Maker.make('2.0') do |m|
      m.channel.title = 'My Anime List'
      m.channel.link = 'http://share.dmhy.org/'
      m.channel.description = 'Download list'
      m.items.do_sort = true
    end

    File.open(@options['output'], 'w') do |f|
      f.write(empty_rss)
    end
  end

  def fetch_online_rss
    content = ''
    failed = false
    begin
      open(@options['source']) { |s| content = s.read }
    rescue Exception
      # retry if 1 time failed
      if failed
        exit
      else
        failed = true
        retry
      end
    end

    RSS::Parser.parse(content, false)
  end

end

config_file = File.join(File.dirname(__FILE__), 'config.yml')
processor = RssProcessor.new(config_file)
processor.process
