from weasyprint import HTML
from weasyprint.text.fonts import FontConfiguration
import re
import argparse

font_config = FontConfiguration()
HTML('docs/index.html').write_pdf( 'build/final.pdf')
    
