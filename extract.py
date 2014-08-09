from bs4 import BeautifulSoup
from  wget import crawl
import bsddb
import sys
import datetime
from pymongo import MongoClient


db=bsddb.btopen("crawledPages.db", "c")


f_all=open("all.csv", "a")
#f_undervalued=open("undervalued", "a")


def extract(link):
	html_doc=crawl(link)
	soup=BeautifulSoup(html_doc, "lxml")
	print soup.title.string
	title=soup.title.string
	stock=soup.find(id="about_primary_stocks").get_text()
	article_body=soup.find(id="article_body").get_text()
	timestamp=str(datetime.datetime.now())
	#print article_body
	undervalued=0
	discount=0
	if(article_body.find("undervalued")>=0 or title.lower().find("undervalued")>=0):
		undervalued=1
	if(article_body.find("discount")>=0):
		discount=1
        f_all.write('"%s","%s",%d,%d,"%s",%s\n'%(soup.title.string, stock, undervalued,discount, link, timestamp))
	print "found undervalued instances: "+ str(article_body.find("undervalued"))
	db[str(link)]='1'
	record={ "title": soup.title.string,
                  "stock": stock, 
                  "link": link, 
                   "timestamp": timestamp, 
                  "content": article_body
	
       		 }
	db_mongo["test_collection"].insert(record)
  

	



#feed_url="http://seekingalpha.com/feed.xml"
feed_url="http://seekingalpha.com/tag/long-ideas.xml"
feed_content=crawl(feed_url)
feed_content=str(feed_content)
soup=BeautifulSoup(feed_content, "xml")
link_arr=soup.find_all("link")

# starting up Mongo Client
client=MongoClient("localhost", 27017)
db_mongo=client.test_database



for link in link_arr:
	try:
		if( db.has_key(str(link.string))!=1):
			extract(link.string)
	except:
		e = sys.exc_info()[0]
		print( "<p>Error: %s</p>" % e )

f_all.close()
db.close()
