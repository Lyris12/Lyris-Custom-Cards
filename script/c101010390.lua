--created & coded by Lyris
--新星光バリア－ギャラクシー・フォース
function c101010390.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c101010390.target)
	e1:SetOperation(c101010390.activate)
	c:RegisterEffect(e1)
end
function c101010390.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>=3 or g:IsExists(Card.IsAbleToRemove,1,nil) end
	if g:GetCount()<3 then Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) end
end
function c101010390.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<3 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	else
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
