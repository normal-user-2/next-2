FROM node:14-alpine AS base

RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY . .

RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile && yarn build; \
  elif [ -f package-lock.json ]; then npm ci && npm run build; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile && pnpm run build; \
  else echo "Lockfile not found." && exit 1; \
  fi

EXPOSE 3000
CMD npm run start
