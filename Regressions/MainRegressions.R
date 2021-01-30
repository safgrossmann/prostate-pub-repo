library(ggplot2)
library(lmerTest)
library(effects)
########################
# Final Age Regression #
########################
#input
glm1 = readRDS("/Users/sg18/volumes/sshfs_mnt/Scripts/Prostate/sensitivity_model_glm1.dat")
MostlyCovered <- read.table("/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/FinalRegressionInput.tsv",
                   sep = "\t", header = T)
var_calls_covered <- MostlyCovered[,c("MedianVAF","SeqX","MutationCount","Age","Donor")] 
colnames(var_calls_covered) <- c('vaf','coverage','rawCount',"Age","Donor")
var_calls_covered$sensitivity = predict(glm1, newdata=var_calls_covered, type='response')
var_calls_covered$correctedCounts <- round(var_calls_covered$rawCount / var_calls_covered$sensitivity)
rm(Conc,Full,glm1,MostlyCovered,threshold)
#generalised linear regression
m_glm <- lmer(correctedCounts ~ Age + (1 | Donor), data = var_calls_covered)
summary(m_glm)
age_glm <- as.data.frame(effects::effect("Age",m_glm,xlevels = list('Age'=c(seq(20,80,by = 5)))))
poly_pos <- data.frame(x = c(age_glm$Age,rev(age_glm$Age)),y = c(age_glm$lower,rev(age_glm$upper)))
#plot
ggplot(var_calls_covered, aes(x=Age,y=correctedCounts,color=Donor)) + geom_jitter(height = 0.1, width = 0.25, alpha = 0.75) +
  geom_line(inherit.aes = F, data = age_glm, aes(x=Age,y=fit)) + 
  geom_polygon(inherit.aes = F, data = poly_pos, aes(x=x, y=y),alpha = 0.4) +
  theme_bw() + ylab('Corrected Mutation Count Per Section')
#plot(lm(correctedCounts ~ Age,data = var_calls_covered))

#############################################
# Telomere Length Regressions in Main Donor #
#############################################
Full <- read.table("/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/PD40870_AllSectionsMetadataForRegressions.tsv",
                   sep = "\t", header = T)
#### VAF vs RootDistance #####
ggplot(data = Full,aes(x = RootDistance, y = vaf)) + geom_point() +
  geom_smooth(method = 'lm')
summary(lm(data = Full,formula = vaf ~ RootDistance))
cor.test(Full$vaf,Full$RootDistance, method = 'kendall') #highly significant

#### VAF vs telomere length ####
ggplot(data = Full,aes(x = vaf, y = TelomereLength)) + geom_point() +
  geom_smooth(method = 'lm')
cor.test(Full$vaf,Full$TelomereLength,method = 'kendall') #p=0.06
summary(lm(data = Full,formula = vaf ~ TelomereLength)) #p=0.1

#### MutCount vs TelomereLength ####
ggplot(data = Full,aes(x = rawCount, y = TelomereLength)) + geom_point() +
  geom_smooth(method = 'lm')
summary(lm(data = Full,formula = rawCount ~ TelomereLength)) #p<2e-16
cor.test(Full$rawCount,Full$TelomereLength,method = 'kendall') #p=4.734e-10

#### Root Distance vs Telomere Length ####
ggplot(data = Full,aes(x = RootDistance, y = TelomereLength)) + geom_point() +
  geom_smooth(method = 'lm')
cor.test(Full$RootDistance,Full$TelomereLength[which(Full$Donor=='PD40870')],method = 'kendall') #p=5.937e-06
summary(lm(data = Full,formula = RootDistance ~ TelomereLength)) #p=1.19e-4

#### Root Distance vs Mut Count ####
ggplot(data = Full,aes(x = RootDistance, y = rawCount)) + geom_point() +
  geom_smooth(method = 'lm')
summary(lm(data = Full,formula = rawCount ~ RootDistance)) #1.5e-09
ggplot(data = Full,aes(x = RootDistance, y = correctedCount)) + geom_point() +
  geom_smooth(method = 'lm')

ggplot(data = MostlyCovered,aes(y = vaf, x = TelomereLength)) + geom_point() +
  geom_smooth(method = 'lm')+ theme_bw() + facet_grid(~Facet) +
  geom_text(data=annotations,aes(x=xpos,y=ypos,hjust=hjustvar,vjust=vjustvar),
            label=c(paste0('Adj Rsq= ',formatC(summary(lm)$adj.r.squared,format = "e", digits=1)),
                    paste0('p = ',formatC(summary(lm)$coefficients[2,4],format = "e", digits=1)))) 