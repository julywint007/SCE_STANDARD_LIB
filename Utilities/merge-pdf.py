import os
import PyPDF2
from PyPDF2 import PdfMerger  

# Import PdfReadError from PyPDF2.errors
from PyPDF2.errors import PdfReadError

merger = PdfMerger()

def is_valid(pdf_path):
  try:
    PyPDF2.PdfReader(pdf_path) 
    return True

  # Catch PdfReadError 
  except PdfReadError as e:
    print(f"Error validating {pdf_path}: {e}")
    return False

for root, dirs, files in os.walk('/mnt/artifacts/TFL'):
  for file in files:
    if file.endswith('.pdf'):
      pdf_path = os.path.join(root, file)
      
      if is_valid(pdf_path):
        print(f"Appending {pdf_path}") 
        merger.append(pdf_path)
      else:
        print(f"Skipping invalid PDF: {pdf_path}")
        
merger.write("/mnt/artifacts/TFL/combined.pdf")
merger.close()
