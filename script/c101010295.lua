--created & coded by Lyris
--ブルーアイズ・ホワイト・ドラゴニス
function c101010295.initial_effect
	if not c101010295.global_check then
		c101010295.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010295.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010295.evolute=true
c101010295.material1=function(mc) return mc:IsCode(89631139) and mc:IsFaceup() end
c101010295.material2=function(mc) return mc:GetLevel()==6 and mc:IsFaceup() end
function c101010295.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
end