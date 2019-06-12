delete from peak where id in (select distinct p.id from spectrum s join scan c  on s.id=c.spectrumid join peak p on p.scan=c.id where filename like ?);
ALTER SEQUENCE "seq_8513" RESTART WITH (SELECT MAX(id) + 1 FROM peak);
delete from scan where id in (select distinct c.id from spectrum s join scan c  on s.id=c.spectrumid where filename like ?)
ALTER SEQUENCE "seq_8415" RESTART WITH (SELECT MAX(id) + 1 FROM scan);