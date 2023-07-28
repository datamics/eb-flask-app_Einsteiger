from flask import Flask


# Begrüßung ausgeben (nur falls die URL mit Parameter aufgerufen wird)
def sag_hallo(name="Welt"):
    return '<p>Hallo %s!</p>\n' % name


# Etwas Texts für die Seite
header_text = '''
    <html>\n<head> <title>Elastic Beanstalk Flask App</title> </head>\n<body>'''

inhalt = '''
    <p>
    <em>Hallo!</em> 
    <br>
    AWS Elastic Beanstalk Flask App als Pipeline mit GitHub Actions zum 
    automatischen Deployment mit Terraform.<br>
    Teil des Terraform-Kurses von Datamics.
    <br>
    </p>\n'''

home_link = '<p><a href="/">Unsere Homepage</a></p>\n'

footer_text = '</body>\n</html>'

# EB schaut per Default automatisch nach einer Callable namens 'application'.
application = Flask(__name__)

# Eine Regel für die Indexseite hinzufügen
application.add_url_rule('/', 'index',
                         (lambda: header_text +
                          sag_hallo() + inhalt + footer_text))

# Regel hinzufügen, wenn die URL mit einem Namen aufgerufen wird.
application.add_url_rule('/<name>', 'hallo',
                         (lambda name:
                          header_text + sag_hallo(name) + home_link + footer_text))

# App ausführen
if __name__ == "__main__":
    # Wird debug auf True gesetzt, so werden Debugging-Nachrichten ausgegeben.
    # Dies sollte in Produktion immmer ausgeschaltet sein.

    # application.debug = True
    # application.run()

    application.run(host='0.0.0.0', port=80)
