from quickweb import controller
import cherrypy
from pprint import pprint
from urllib.parse import unquote
import ssl
from tempfile import NamedTemporaryFile


class Controller(object):
    @controller.publish
    def default(*args, **kwargs):
        pprint(cherrypy.request.headers.keys())
        pem_string = unquote(cherrypy.request.headers['X-Ssl-Client-Cert'])
        with NamedTemporaryFile() as tmp_cert:
            tmp_cert.write(bytes(pem_string, 'ascii'))
            tmp_cert.flush()
            cert_dict = ssl._ssl._test_decode_cert(tmp_cert.name)
            pprint(cert_dict)
        return "Python"