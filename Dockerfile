FROM node:20-bullseye AS build

ARG PUBLIC_APPWRITE_COL_MESSAGES_ID
ENV PUBLIC_APPWRITE_COL_MESSAGES_ID ${PUBLIC_APPWRITE_COL_MESSAGES_ID}

ARG PUBLIC_APPWRITE_COL_THREADS_ID
ENV PUBLIC_APPWRITE_COL_THREADS_ID ${PUBLIC_APPWRITE_COL_THREADS_ID}

ARG PUBLIC_APPWRITE_DB_MAIN_ID
ENV PUBLIC_APPWRITE_DB_MAIN_ID ${PUBLIC_APPWRITE_DB_MAIN_ID}

ARG PUBLIC_APPWRITE_FN_TLDR_ID
ENV PUBLIC_APPWRITE_FN_TLDR_ID ${PUBLIC_APPWRITE_FN_TLDR_ID}

ARG PUBLIC_APPWRITE_PROJECT_ID
ENV PUBLIC_APPWRITE_PROJECT_ID ${PUBLIC_APPWRITE_PROJECT_ID}

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

WORKDIR /app
COPY . .

RUN corepack enable
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install
RUN NODE_OPTIONS=--max_old_space_size=4096 pnpm run build

# Node alpine image to serve the generated static files
FROM node:20-alpine AS serve

WORKDIR /app
COPY --from=build /app .

EXPOSE 3000
CMD [ "node", "server/main.js"]