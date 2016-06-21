--Victorial Wield Taurus
local id,ref=GIR()
function ref.start(c)
--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1068)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(ref.target)
	e0:SetOperation(ref.operation)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
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
	e2:SetCondition(ref.damcon)
	e2:SetTarget(ref.damtg)
	e2:SetOperation(ref.damop)
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
	e3:SetTarget(ref.sptg)
	e3:SetOperation(ref.spop)
	c:RegisterEffect(e3)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function ref.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function ref.filter(c,e,tp,m)
	if not c:IsCode(id) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetOriginalLevel(),1,99,c)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
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
function ref.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetControler()==tp and ec==Duel.GetAttacker() and ec:GetBattleTarget()
end
function ref.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetEquipTarget()
	local bc=tc:GetBattleTarget()
	local atk1=tc:GetAttack()
	local atk2=bc:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.abs(atk1-atk2))
end
function ref.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	local bc=tc:GetBattleTarget()
	if tc:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local atk1=tc:GetAttack()
		local atk2=bc:GetAttack()
		if atk1==atk2 then return end
		Duel.Damage(1-tp,math.abs(atk1-atk2),REASON_EFFECT)
	end
end
