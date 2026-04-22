package com.example.gutapp.service;

import com.example.gutapp.models.EmailDetails;
import com.example.gutapp.repository.EmailService;
import java.io.File;
import jakarta.mail.MessagingException; // The base class for all exceptions thrown by the Messaging classes

import jakarta.mail.internet.MimeMessage; // Implementation of the MailMessage interface for a JavaMail MIME message, to let message population code interact with a simple message or a MIME message through a common interface.
// Multipurpose Internet Mail Extensions (MIME) standard

import org.springframework.beans.factory.annotation.Autowired; // dependancy injection .. this is equivalent to a property injection.
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailServiceImpl implements EmailService {

    @Autowired
    private JavaMailSender javaMailSender;
    @Value("${spring.mail.username}") // uses username from properties file.
    private String sender;

    // Send simple mail - implements function in service.
    public String sendSimpleMail(EmailDetails details) {

        try {

            SimpleMailMessage mailMessage = new SimpleMailMessage();

            mailMessage.setFrom(sender);
            mailMessage.setTo(details.getRecipient());
            mailMessage.setText(details.getMsgBody());
            mailMessage.setSubject(details.getSubject());

            javaMailSender.send(mailMessage);

            return "Mail Sent Successfully";

        } catch (Exception e) {

            return "Error while sending mail"; // this is whats trigggered when i try testing i think the password is the issue!!
        }
    }

    // Send mail with attachment
    public String sendMailWithAttachment(
            EmailDetails details) {

        MimeMessage mimeMessage =
                javaMailSender.createMimeMessage();

        MimeMessageHelper helper;

        try {

            helper =
                    new MimeMessageHelper(mimeMessage, true);

            helper.setFrom(sender);
            helper.setTo(details.getRecipient());
            helper.setText(details.getMsgBody());
            helper.setSubject(details.getSubject());

            // file handling //
            FileSystemResource file = new FileSystemResource(new File(details.getAttachment())); // attachment === filepath to csv.

            helper.addAttachment(file.getFilename(), file);

            javaMailSender.send(mimeMessage);

            return "Attachment Sent Successfully";

        } catch (MessagingException e) {

            return "Error while sending attachment";
        }
    }
}