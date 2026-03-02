# Stage 1: Temporary downloader
# Use the official image to pull weights
FROM docker.io/ollama/ollama:0.15.2 AS downloader

# Start server and pull your desired model (e.g., llama3)
RUN ollama serve & sleep 5 && ollama pull glm-4.7-flash

# Stage 2: Build the Salad-optimized image
FROM docker.io/saladtechnologies/ollama:0.15.2

# Copy the pre-loaded model data from the downloader stage
# Ollama stores model weights in /root/.ollama
COPY --from=downloader /root/.ollama /root/.ollama

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install btop, nvtop, and terminfo
RUN apt-get update && \
    apt-get install --no-install-recommends -y btop nvtop ncurses-term terminfo vim htop && \
    apt-get clean

# Salad-specific environment variables (often already in the base)
#ENV OLLAMA_HOST="[::]:11434"

#EXPOSE 11434
# No need for a custom ENTRYPOINT if the base image already handles it
