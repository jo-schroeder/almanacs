import pdfplumber

# Load the PDF
pdf_path = "almanac-test.pdf"  # Replace with your PDF file path

with pdfplumber.open(pdf_path) as pdf:
    for page_num, page in enumerate(pdf.pages):
        page_text = page.extract_text()
        print(f"--- Page {page_num + 1} ---")
        print(page_text)
        print("\n")