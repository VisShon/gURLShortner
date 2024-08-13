# db/seeds.rb

# Clear existing records in the short_urls table
ShortUrl.destroy_all

# Array of URLs and their corresponding titles
urls = [
  { full_url: 'https://www.google.com', title: 'Google' },
  { full_url: 'https://www.facebook.com', title: 'Facebook' },
  { full_url: 'https://www.twitter.com', title: 'Twitter' },
  { full_url: 'https://www.linkedin.com', title: 'LinkedIn' },
  { full_url: 'https://www.github.com', title: 'GitHub' },
  { full_url: 'https://www.stackoverflow.com', title: 'Stack Overflow' },
  { full_url: 'https://www.reddit.com', title: 'Reddit' },
  { full_url: 'https://www.medium.com', title: 'Medium' },
  { full_url: 'https://www.amazon.com', title: 'Amazon' },
  { full_url: 'https://www.netflix.com', title: 'Netflix' },
  { full_url: 'https://www.spotify.com', title: 'Spotify' },
  { full_url: 'https://www.apple.com', title: 'Apple' },
  { full_url: 'https://www.microsoft.com', title: 'Microsoft' },
  { full_url: 'https://www.coursera.org', title: 'Coursera' },
  { full_url: 'https://www.udemy.com', title: 'Udemy' },
  { full_url: 'https://www.edx.org', title: 'edX' },
  { full_url: 'https://www.khanacademy.org', title: 'Khan Academy' },
  { full_url: 'https://www.wikipedia.org', title: 'Wikipedia' },
  { full_url: 'https://www.imdb.com', title: 'IMDb' },
  { full_url: 'https://www.quora.com', title: 'Quora' },
  { full_url: 'https://www.theverge.com', title: 'The Verge' },
  { full_url: 'https://www.techcrunch.com', title: 'TechCrunch' },
  { full_url: 'https://www.nytimes.com', title: 'The New York Times' },
  { full_url: 'https://www.bbc.com', title: 'BBC' },
  { full_url: 'https://www.cnn.com', title: 'CNN' },
  { full_url: 'https://www.forbes.com', title: 'Forbes' },
  { full_url: 'https://www.huffpost.com', title: 'HuffPost' },
  { full_url: 'https://www.wsj.com', title: 'The Wall Street Journal' },
  { full_url: 'https://www.bloomberg.com', title: 'Bloomberg' },
  { full_url: 'https://www.ted.com', title: 'TED' },
  { full_url: 'https://www.airbnb.com', title: 'Airbnb' },
  { full_url: 'https://www.booking.com', title: 'Booking.com' },
  { full_url: 'https://www.tripadvisor.com', title: 'Tripadvisor' },
  { full_url: 'https://www.yelp.com', title: 'Yelp' },
  { full_url: 'https://www.zillow.com', title: 'Zillow' },
  { full_url: 'https://www.indeed.com', title: 'Indeed' },
  { full_url: 'https://www.monster.com', title: 'Monster' },
  { full_url: 'https://www.glassdoor.com', title: 'Glassdoor' },
  { full_url: 'https://www.slack.com', title: 'Slack' },
  { full_url: 'https://www.dropbox.com', title: 'Dropbox' },
  { full_url: 'https://www.trello.com', title: 'Trello' },
  { full_url: 'https://www.asana.com', title: 'Asana' },
  { full_url: 'https://www.figma.com', title: 'Figma' },
  { full_url: 'https://www.adobe.com', title: 'Adobe' },
  { full_url: 'https://www.canva.com', title: 'Canva' },
  { full_url: 'https://www.pinterest.com', title: 'Pinterest' },
  { full_url: 'https://www.instagram.com', title: 'Instagram' },
  { full_url: 'https://www.tiktok.com', title: 'TikTok' },
  { full_url: 'https://www.snapchat.com', title: 'Snapchat' }
]
# Create records in the short_urls table
urls.each do |url|
  ShortUrl.create!(
    full_url: url[:full_url],
    title: url[:title],
  )
end

puts "Seeded #{urls.size} short URLs."
