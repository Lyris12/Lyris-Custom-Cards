--Victorial Wield Taurus
function c101010309.initial_effect(c)
	aux.AddEquipProcedure(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101010309.damcon)
	e2:SetTarget(c101010309.damtg)
	e2:SetOperation(c101010309.damop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(2)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetAttacker()==e:GetHandler():GetEquipTarget() end)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end Duel.SendtoGrave(e:GetHandler(),REASON_COST) end)
	e3:SetTarget(c101010309.sptg)
	e3:SetOperation(c101010309.spop)
	c:RegisterEffect(e3)
end
function c101010309.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c101010309.filter(c,e,tp,m)
	if not c:IsCode(101010309) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetOriginalLevel(),1,99,c)
end
function c101010309.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c101010309.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101010309.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c101010309.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--When the equipped monster attacks an opponent's monster: inflict damage to your opponent equal to the difference between the battling monsters' ATKs.
function c101010309.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetControler()==tp and ec==Duel.GetAttacker() and ec:GetBattleTarget()
end
function c101010309.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetEquipTarget()
	local bc=tc:GetBattleTarget()
	local atk1=tc:GetAttack()
	local atk2=bc:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.abs(atk1-atk2))
end
function c101010309.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	local bc=tc:GetBattleTarget()
	if tc:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local atk1=tc:GetAttack()
		local atk2=bc:GetAttack()
		if atk1==atk2 then return end
		Duel.Damage(1-tp,math.abs(atk1-atk2),REASON_EFFECT)
	end
end
