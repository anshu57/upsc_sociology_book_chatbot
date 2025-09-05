from langchain.document_loaders import PyPDFLoader, DirectoryLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_experimental.text_splitter import SemanticChunker
from langchain_huggingface import HuggingFaceEmbeddings


def load_pdf_files(data):
    loader = DirectoryLoader(
        data,
        glob= "*.pdf",
        loader_cls=PyPDFLoader
    )

    documents = loader.load()
    return documents



from typing import List
from langchain.schema import Document

def filter_to_minimal_docs(docs: List[Document])-> List[Document]:

    minimal_docs: List[Document] = []
    for doc in docs:
        src = doc.metadata.get("source")
        minimal_docs.append(
            Document(
                page_content=doc.page_content,
                metadata={"source": src}
            )
        )
    return minimal_docs


# split the documents

def text_split(minimal_docs):
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size = 500,
        chunk_overlap = 20,
        length_function = len
    )

    texts_chunks = text_splitter.split_documents(minimal_docs)
    return texts_chunks

def download_hugging_face_embeddings():
    embedding = HuggingFaceEmbeddings(model_name='sentence-transformers/all-MiniLM-L6-v2')
    return embedding


import re

def clean_chatbot_output(text):
    """
    Cleans chatbot output by removing markdown and special characters.

    Args:
        text (str): The raw text from the chatbot model.

    Returns:
        str: The cleaned, readable text.
    """
    # Remove asterisks used for bolding or lists
    text = re.sub(r'\*', '', text)
    # Remove bullet points (e.g., '-', '*') and extra spaces
    text = re.sub(r'•\s*|\-\s*', '', text)
    # Remove excessive newlines, keeping only a single line break between paragraphs
    text = re.sub(r'\n\s*\n', '\n\n', text.strip())
    # Remove any leading/trailing whitespace
    text = text.strip()
    return text
    