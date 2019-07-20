

# Motor Trend Car Road Tests
data(mtcars)

boxplot(mpg ~ cyl, data = mtcars)
plot(mpg ~ disp, data = mtcars)

f <- lm(mpg ~ cyl + disp + hp + drat + wt + qsec + vs + am + gear + carb,
        data = mtcars)
# f <- lm(mpg ~ .,
#         data = mtcars)
summary(f)

par(mfrow = c(2,2))
plot(f)
par(mfrow = c(1,1))
