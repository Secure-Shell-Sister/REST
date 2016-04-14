__author__ = 'DickyIrwanto'
import json,urllib2,sys
import operator
import time
if __name__ == '__main__':
    if len(sys.argv) > 1:
        u = sys.argv[1]
    time_start = time.time()
    url = 'http://' + u + ':5000/security/'
    response = urllib2.urlopen(url)
    try:
        result = json.load(response)
        print result
        try:
            arr = sorted(result, key=result.__getitem__, reverse=True)                
            for x in arr:
                print x, result[x]
            print time.time()-time_start,'seconds'
        except:
            print 'Error Extraction Proccess'
            print sys.error_info[0]
    except:
        print 'Error Connection'
