FROM node:14-alpine AS base

RUN apk add --no-cache libc6-compat

WORKDIR /app

ENV NEXT_TELEMETRY_DISABLED 1
ENV NODE_ENV production

COPY . .

RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm install; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

RUN \
  if [ -f yarn.lock ]; then yarn build; \
  elif [ -f package-lock.json ]; then npm run build; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm run build; \
  else echo "Lockfile not found." && exit 1; \
  fi

EXPOSE 3000
CMD npm run start
