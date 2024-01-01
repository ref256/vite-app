########################
# Dependencies stage   #
########################
FROM node:20-alpine as deps

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile

########################
# Builder stage        #
########################
FROM deps as builder

COPY . .

# Linting
# RUN yarn lint

# Type checking
# RUN yarn tsc

# Testing (unit)
# RUN yarn test:ci

# Building
RUN yarn build

#########################
## Bundling             #
#########################
FROM nginx:1.16.0-alpine

COPY --from=builder /app/dist /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
