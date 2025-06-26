package util;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class DBConnection {
    private static SqlSessionFactory factory;

    static {
        System.out.println("[DBConnection] 초기화 시작");
        try {
            factory = new SqlSessionFactoryBuilder()
                .build(Resources.getResourceAsReader("util/config.xml"));
            System.out.println("[DBConnection] config.xml 로딩 성공");
        } catch (Exception e) {
            System.out.println("[DBConnection] 초기화 실패!!");
            e.printStackTrace();
            throw new RuntimeException(e);  // 💥 이거 추가해줘서 오류를 바로 보이게
        }
    }

    public static SqlSessionFactory getFactory() {
        return factory;
    }

	public SqlSession getSession() {
		  return factory.openSession();
		// TODO Auto-generated method stub
	}
}