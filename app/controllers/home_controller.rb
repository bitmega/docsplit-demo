class HomeController < ApplicationController
  def index
  end
  
  def extract 
    @content = extract_content(params[:pdf_file])
    
    render :index
  end
  
  private
  
  def extract_content(file_param)
    pdf_file = file_param

    # Save the file to a temporary location on the server
    file_path = Rails.root.join('tmp', pdf_file.original_filename)
    File.open(file_path, 'wb') do |file|
      file.write(pdf_file.read)
    end
    
    # Extract the content from the PDF file
    Docsplit.extract_text(file_path, :ocr => false, output: Rails.root.join('tmp'))

    # Read the extracted text from the output file
    output_path = Rails.root.join("tmp", "#{File.basename(file_path, ".pdf")}.txt")
    
    extracted_content = File.read(output_path)

    # Delete the temporary files
    File.delete(file_path)
    File.delete(output_path)

    # Do something with the extracted content
    return extracted_content
  end
end
