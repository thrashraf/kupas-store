# Use a specific version of node to ensure consistent builds
FROM node:16-slim

# Install dependencies in a separate layer to leverage Docker cache
WORKDIR /app/medusa

# Install system dependencies required for your application
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python-is-python3 \
    && rm -rf /var/lib/apt/lists/*

# Copy package.json and yarn.lock first to cache dependencies installation
COPY package.json yarn.lock ./

# Install Medusa CLI globally and project dependencies
RUN yarn global add @medusajs/medusa-cli && yarn install

# Copy the rest of your application code
COPY . .

# Build your application
RUN yarn build

# Command to run migrations and start the app
CMD ["sh", "-c", "medusa migrations run && yarn start"]
