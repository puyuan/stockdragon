import subprocess

url="http://google.com"
def crawl(url):
	command=["wget", "-O", "-",  url]
	#pipe=subprocess.Popen(command, stdout=subprocess.PIPE)
	pipe=subprocess.Popen(command, stdout=subprocess.PIPE)
	stdout, stderr=pipe.communicate()
	return stdout
	#pipe.close()

def unit_test():
	crawl("http://www.yahoo.com")

